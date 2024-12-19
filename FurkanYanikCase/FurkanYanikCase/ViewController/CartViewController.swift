//
//  CartViewController.swift
//  FurkanYanikCase
//
//  Created by Furkan Yanık on 18.12.2024.
//

import UIKit

class CartViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    private let tableView = UITableView()
    private let bottomView = UIView()
    private let totalTitleLabel = UILabel()
    private let totalLabel = UILabel()
    private let completeButton = UIButton()
    
    private let viewModel = CartViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupTableView()
        setupBottomView()

        viewModel.onDataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.updateTotal()
                self?.tableView.reloadData()
            }
        }
        
        viewModel.loadCart()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadCart()
    }
    
    func setupTableView() {
        contentView.addSubview(tableView)
        contentView.addSubview(bottomView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.translatesAutoresizingMaskIntoConstraints = false

        
        tableView.register(CartCell.self, forCellReuseIdentifier: "CartCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            tableView.bottomAnchor.constraint(equalTo: bottomView.topAnchor, constant: -8),
            
            bottomView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 8),
            bottomView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    func setupBottomView() {
        contentView.addSubview(bottomView)
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.backgroundColor = .white
        bottomView.heightAnchor.constraint(equalToConstant: 61).isActive = true
        
        totalTitleLabel.text = "Total:"
        totalTitleLabel.textColor = UIColor(red: 0/255, green: 95/255, blue: 238/255, alpha: 1.0)
        totalTitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        bottomView.addSubview(totalTitleLabel)
        totalTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        totalLabel.font = UIFont.boldSystemFont(ofSize: 20)
        bottomView.addSubview(totalLabel)
        totalLabel.translatesAutoresizingMaskIntoConstraints = false
        
        completeButton.setTitle("Complete", for: .normal)
        completeButton.backgroundColor = UIColor(red: 0/255, green: 95/255, blue: 238/255, alpha: 1.0)
        completeButton.setTitleColor(.white, for: .normal)
        completeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        completeButton.layer.cornerRadius = 8
        bottomView.addSubview(completeButton)
        completeButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            bottomView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 8),
            bottomView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            totalTitleLabel.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 8),
            totalTitleLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 16),
            
            totalLabel.topAnchor.constraint(equalTo: totalTitleLabel.bottomAnchor, constant: 4),
            totalLabel.leadingAnchor.constraint(equalTo: totalTitleLabel.leadingAnchor),
            
            completeButton.centerYAnchor.constraint(equalTo: totalLabel.topAnchor, constant: 0),
            completeButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -16),
            completeButton.widthAnchor.constraint(equalToConstant: 100),
            completeButton.heightAnchor.constraint(equalToConstant: 40),
            bottomView.bottomAnchor.constraint(greaterThanOrEqualTo: completeButton.bottomAnchor, constant: 16)
        ])
    }

    private func updateTotal() {
        let total = viewModel.totalCost()
        totalLabel.text = total
    }

    // MARK: TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartCell
        let item = viewModel.item(at: indexPath.row)
        let quantity = Int(item.quantity)
        let price = item.price ?? "0₺"
        let name = item.name ?? "Unknown Product"
        cell.configure(name: name, price: price, quantity: quantity)
        
        cell.onIncrement = { [weak self] in
            self?.viewModel.incrementQuantity(at: indexPath.row)
        }
        
        cell.onDecrement = { [weak self] in
            self?.viewModel.decrementQuantity(at: indexPath.row)
        }

        return cell
    }
}
