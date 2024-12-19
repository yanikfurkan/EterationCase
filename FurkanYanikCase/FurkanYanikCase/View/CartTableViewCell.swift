//
//  CartTableViewCell.swift
//  FurkanYanikCase
//
//  Created by Furkan Yanık on 19.12.2024.
//

import UIKit

class CartCell: UITableViewCell {
    private let nameLabel = UILabel()
    private let priceLabel = UILabel()
    private let quantityContainer = UIView()
    private let minusButton = UIButton()
    private let plusButton = UIButton()
    private let quantityLabel = UILabel()

    var onIncrement: (() -> Void)?
    var onDecrement: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none

        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        nameLabel.textColor = .black

        priceLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        priceLabel.textColor = UIColor(red: 0/255, green: 95/255, blue: 238/255, alpha: 1.0)

        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        [minusButton, quantityLabel, plusButton].forEach { quantityContainer.addSubview($0) }
        contentView.addSubview(quantityContainer)

        quantityContainer.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        minusButton.translatesAutoresizingMaskIntoConstraints = false
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        quantityLabel.translatesAutoresizingMaskIntoConstraints = false

        minusButton.setTitle("-", for: .normal)
        minusButton.setTitleColor(.darkGray, for: .normal)
        minusButton.backgroundColor = UIColor(white: 0.9, alpha: 1)
        minusButton.addTarget(self, action: #selector(didTapMinus), for: .touchUpInside)

        plusButton.setTitle("+", for: .normal)
        plusButton.setTitleColor(.darkGray, for: .normal)
        plusButton.backgroundColor = UIColor(white: 0.9, alpha: 1)
        plusButton.addTarget(self, action: #selector(didTapPlus), for: .touchUpInside)

        quantityLabel.textAlignment = .center
        quantityLabel.textColor = .white
        quantityLabel.backgroundColor = UIColor(red: 0/255, green: 95/255, blue: 238/255, alpha: 1.0)
        quantityLabel.font = UIFont.boldSystemFont(ofSize: 16)

        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            priceLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            quantityContainer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            quantityContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            quantityContainer.heightAnchor.constraint(equalToConstant: 40),
            quantityContainer.widthAnchor.constraint(equalToConstant: 120),
            
            minusButton.leadingAnchor.constraint(equalTo: quantityContainer.leadingAnchor),
            minusButton.topAnchor.constraint(equalTo: quantityContainer.topAnchor),
            minusButton.bottomAnchor.constraint(equalTo: quantityContainer.bottomAnchor),
            minusButton.widthAnchor.constraint(equalToConstant: 40),
            
            quantityLabel.leadingAnchor.constraint(equalTo: minusButton.trailingAnchor),
            quantityLabel.topAnchor.constraint(equalTo: quantityContainer.topAnchor),
            quantityLabel.bottomAnchor.constraint(equalTo: quantityContainer.bottomAnchor),
            quantityLabel.widthAnchor.constraint(equalToConstant: 40),
            
            plusButton.leadingAnchor.constraint(equalTo: quantityLabel.trailingAnchor),
            plusButton.topAnchor.constraint(equalTo: quantityContainer.topAnchor),
            plusButton.bottomAnchor.constraint(equalTo: quantityContainer.bottomAnchor),
            plusButton.trailingAnchor.constraint(equalTo: quantityContainer.trailingAnchor),
            plusButton.widthAnchor.constraint(equalToConstant: 40),
            
            contentView.bottomAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 12)
        ])
    }

    @objc func didTapMinus() {
        onDecrement?()
    }

    @objc func didTapPlus() {
        onIncrement?()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(name: String, price: String, quantity: Int) {
        nameLabel.text = name
        priceLabel.text = price
        quantityLabel.text = "\(quantity)"
    }
}
