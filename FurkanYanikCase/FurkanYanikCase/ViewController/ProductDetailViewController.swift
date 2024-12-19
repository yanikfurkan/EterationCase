//
//  ProductDetailViewController.swift
//  FurkanYanikCase
//
//  Created by Furkan Yanık on 18.12.2024.
//

import UIKit

class ProductDetailViewController: BaseViewController {
    private let backButton = UIButton(type: .system)
    private let productNameLabelInHeader = UILabel()
    
    private let productImageView = UIImageView()
    private let detailFavoriteButton = UIButton(type: .system)
    private let productNameLabel = UILabel()
    private var productDescriptionTextView = UITextView()
    private let priceLabel = UILabel()
    private let addToCartButton = UIButton(type: .system)

    private let viewModel: ProductDetailViewModel

    init(viewModel: ProductDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true

        setupHeader()
        setupUI()
        configureUI()
    }

    func setupHeader() {
        headerView.addSubview(backButton)
        backButton.setTitle("< Back", for: .normal)
        backButton.setTitleColor(.white, for: .normal)
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false

        headerView.addSubview(productNameLabelInHeader)
        productNameLabelInHeader.font = UIFont.boldSystemFont(ofSize: 18)
        productNameLabelInHeader.textColor = .white
        productNameLabelInHeader.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 18),
            backButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),

            productNameLabelInHeader.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            productNameLabelInHeader.centerXAnchor.constraint(equalTo: headerView.centerXAnchor)
        ])
    }
    
    func setupUI() {
        contentView.addSubview(productImageView)
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        productImageView.contentMode = .scaleToFill
        productImageView.clipsToBounds = true

        contentView.addSubview(detailFavoriteButton)
        detailFavoriteButton.translatesAutoresizingMaskIntoConstraints = false
        detailFavoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        detailFavoriteButton.tintColor = .lightGray
        detailFavoriteButton.addTarget(self, action: #selector(didTapFavorite), for: .touchUpInside)

        contentView.addSubview(productNameLabel)
        productNameLabel.translatesAutoresizingMaskIntoConstraints = false
        productNameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        productNameLabel.numberOfLines = 0

        productDescriptionTextView = UITextView()
        productDescriptionTextView.isScrollEnabled = true
        productDescriptionTextView.isEditable = false
        productDescriptionTextView.isSelectable = false
        productDescriptionTextView.font = UIFont.systemFont(ofSize: 14)
        productDescriptionTextView.textColor = .black
        productDescriptionTextView.backgroundColor = .clear
        contentView.addSubview(productDescriptionTextView)
        productDescriptionTextView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(priceLabel)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.numberOfLines = 2

        contentView.addSubview(addToCartButton)
        addToCartButton.translatesAutoresizingMaskIntoConstraints = false
        addToCartButton.setTitle("Add to Cart", for: .normal)
        addToCartButton.backgroundColor = UIColor(red: 0/255, green: 95/255, blue: 238/255, alpha: 1)
        addToCartButton.setTitleColor(.white, for: .normal)
        addToCartButton.layer.cornerRadius = 8
        addToCartButton.addTarget(self, action: #selector(didTapAddToCart), for: .touchUpInside)

        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 16),
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            productImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            productImageView.heightAnchor.constraint(equalToConstant: 255),

            detailFavoriteButton.topAnchor.constraint(equalTo: productImageView.topAnchor, constant: 16),
            detailFavoriteButton.trailingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: -16),
            detailFavoriteButton.widthAnchor.constraint(equalToConstant: 24),
            detailFavoriteButton.heightAnchor.constraint(equalToConstant: 24),

            productNameLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 16),
            productNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            productNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            productDescriptionTextView.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor, constant: 16),
            productDescriptionTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            productDescriptionTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            productDescriptionTextView.bottomAnchor.constraint(equalTo: priceLabel.topAnchor, constant: -16),

            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            priceLabel.heightAnchor.constraint(equalToConstant: 44),
            
            addToCartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            addToCartButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            addToCartButton.widthAnchor.constraint(equalToConstant: 182),
            addToCartButton.heightAnchor.constraint(equalToConstant: 38)
        ])
    }


    func configureUI() {
        productNameLabelInHeader.text = viewModel.productName
        productNameLabel.text = viewModel.productName
        productDescriptionTextView.text = viewModel.productDescription
        priceLabel.text = "Price:\n\(viewModel.productPrice)"

        // Resim yükleme
        if let url = viewModel.productImageURL {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data, let img = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.productImageView.image = img
                    }
                }
            }.resume()
        }

        updateFavoriteButton()
    }



    private func updateFavoriteButton() {
        let isFav = viewModel.isFavorite
        let imageName = isFav ? "star.fill" : "star.fill"
        let tintColor = isFav ? UIColor.systemYellow : UIColor.lightGray
        let image = UIImage(systemName: imageName)?.withRenderingMode(.alwaysTemplate)
        detailFavoriteButton.setImage(image, for: .normal)
        detailFavoriteButton.tintColor = tintColor
    }

    @objc func didTapBack() {
        navigationController?.popViewController(animated: true)
    }

    @objc func didTapFavorite() {
        viewModel.toggleFavorite()
        updateFavoriteButton()
    }

    @objc func didTapAddToCart() {
        viewModel.addToCart()
    }
}
