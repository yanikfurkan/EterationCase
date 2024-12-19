//
//  FilterViewController.swift
//  FurkanYanikCase
//
//  Created by Furkan Yanık on 18.12.2024.
//


import UIKit

class FilterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var onApplyFilters: (([String:Any]) -> Void)?

    private let closeButton = UIButton(type: .system)
    private let applyButton = UIButton(type: .system)

    private let tableView = UITableView()
    private var sortOptions = ["Old to new", "New to old", "Price high to low", "Price low to high"]
    private var selectedSort: String?

    private var brands: [String] = ["Apple", "Samsung", "Huawei"] // Dinamik yapabilirsin
    private var selectedBrand: String?
    private var models: [String] = []
    private var selectedModels: Set<String> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        // Close Button
        closeButton.setTitle("X", for: .normal)
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        view.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = "Filter"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        applyButton.setTitle("Primary", for: .normal)
        applyButton.backgroundColor = UIColor.systemBlue
        applyButton.setTitleColor(.white, for: .normal)
        applyButton.layer.cornerRadius = 8
        applyButton.addTarget(self, action: #selector(didTapApply), for: .touchUpInside)
        view.addSubview(applyButton)
        applyButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self

        // Layout
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            titleLabel.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            applyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            applyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            applyButton.widthAnchor.constraint(equalToConstant: 100),
            applyButton.heightAnchor.constraint(equalToConstant: 40),

            tableView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: applyButton.topAnchor, constant: -16)
        ])
    }

    @objc func didTapClose() {
        dismiss(animated: true, completion: nil)
    }

    @objc func didTapApply() {
        var filters: [String:Any] = [:]
        if let sort = selectedSort {
            filters["sort"] = sort
        }
        if let brand = selectedBrand {
            filters["brand"] = brand
        }
        if !selectedModels.isEmpty {
            filters["models"] = Array(selectedModels)
        }
        onApplyFilters?(filters)
        dismiss(animated: true, completion: nil)
    }

    // MARK: TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3 // Sort, Brand, Model
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return sortOptions.count
        case 1:
            return brands.count
        case 2:
            return models.count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Sort By"
        case 1: return "Brand"
        case 2: return "Model"
        default: return nil
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            selectedSort = sortOptions[indexPath.row]
            tableView.reloadSections(IndexSet(integer: 0), with: .none)
        case 1:
            selectedBrand = brands[indexPath.row]
            models = loadModels(for: selectedBrand!)
            selectedModels.removeAll()
            tableView.reloadSections(IndexSet(integer: 2), with: .automatic)
            tableView.reloadSections(IndexSet(integer: 1), with: .none)
        case 2:
            let model = models[indexPath.row]
            if selectedModels.contains(model) {
                selectedModels.remove(model)
            } else {
                selectedModels.insert(model)
            }
            tableView.reloadRows(at: [indexPath], with: .none)
        default:
            break
        }
    }

    func loadModels(for brand: String) -> [String] {
        switch brand {
        case "Apple": return ["iPhone 11", "iPhone 12 Pro", "iPhone 13 Pro Max"]
        case "Samsung": return ["Galaxy S21", "Galaxy S22", "Galaxy Note"]
        case "Huawei": return ["P30", "P40", "Mate 40"]
        default: return []
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)

        switch indexPath.section {
        case 0:
            let sort = sortOptions[indexPath.row]
            cell.textLabel?.text = sort
            cell.accessoryType = (sort == selectedSort) ? .checkmark : .none
        case 1:
            let brand = brands[indexPath.row]
            cell.textLabel?.text = brand
            cell.accessoryType = (brand == selectedBrand) ? .checkmark : .none
        case 2:
            let model = models[indexPath.row]
            cell.textLabel?.text = model
            cell.accessoryType = selectedModels.contains(model) ? .checkmark : .none
        default:
            break
        }
        return cell
    }
}
