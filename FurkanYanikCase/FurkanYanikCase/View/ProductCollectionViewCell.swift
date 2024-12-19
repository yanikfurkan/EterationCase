//
//  ProductCollectionViewCell.swift
//  FurkanYanikCase
//
//  Created by Furkan Yanık on 18.12.2024.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    private let imageView = UIImageView()
    private let priceLabel = UILabel()
    private let nameLabel = UILabel()
    private let addToCartButton = UIButton()
    private let starButton = UIButton()

    var onAddToCart: (() -> Void)?
    private var currentImageURL: URL?
    private var isFavorite = false {
        didSet {
            updateStarAppearance()
        }
    }

    // Basit statik cache
    static var imageCache = [URL: UIImage]()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 8

        imageView.contentMode = .scaleToFill
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false

        priceLabel.font = UIFont.systemFont(ofSize: 14)
        priceLabel.textColor = UIColor(red: 0/255, green: 95/255, blue: 238/255, alpha: 1)
        contentView.addSubview(priceLabel)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false

        nameLabel.font = UIFont.systemFont(ofSize: 14)
        nameLabel.textColor = .black
        nameLabel.numberOfLines = 2
        contentView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        addToCartButton.setTitle("Add to Cart", for: .normal)
        addToCartButton.backgroundColor = UIColor(red: 0/255, green: 95/255, blue: 238/255, alpha: 1)
        addToCartButton.setTitleColor(.white, for: .normal)
        addToCartButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        addToCartButton.layer.cornerRadius = 4
        addToCartButton.addTarget(self, action: #selector(didTapAdd), for: .touchUpInside)
        contentView.addSubview(addToCartButton)
        addToCartButton.translatesAutoresizingMaskIntoConstraints = false

        starButton.addTarget(self, action: #selector(didTapStar), for: .touchUpInside)
        contentView.addSubview(starButton)
        starButton.translatesAutoresizingMaskIntoConstraints = false
        starButton.tintColor = .lightGray
        starButton.setImage(UIImage(systemName: "star.fill"), for: .normal)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor), // kare

            // Yıldız butonu: imageView içinde, üst ve sağdan 4 px içeride
            starButton.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 4),
            starButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -4),
            starButton.widthAnchor.constraint(equalToConstant: 20),
            starButton.heightAnchor.constraint(equalToConstant: 20),

            priceLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 15),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),

            nameLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 15),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            nameLabel.heightAnchor.constraint(equalToConstant: 34),

            addToCartButton.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 15),
            addToCartButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            addToCartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            addToCartButton.heightAnchor.constraint(equalToConstant: 36),
            addToCartButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])

        isFavorite = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func didTapAdd() {
        onAddToCart?()
    }

    @objc func didTapStar() {
        isFavorite.toggle()
    }

    private func updateStarAppearance() {
        let imageName = isFavorite ? "star.fill" : "star"
        let tintColor = isFavorite ? UIColor.systemYellow : UIColor.lightGray
        let image = UIImage(systemName: imageName)?.withRenderingMode(.alwaysTemplate)
        starButton.setImage(image, for: .normal)
        starButton.tintColor = tintColor
        starButton.backgroundColor = .clear
    }

    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        currentImageURL = nil
    }

    func configure(with product: Product) {
        
        imageView.image = nil
        currentImageURL = nil

        priceLabel.text = product.price + " ₺"
        nameLabel.text = product.name

        guard let url = URL(string: product.image) else { return }
        currentImageURL = url

        
        if let cachedImage = ProductCollectionViewCell.imageCache[url] {
            imageView.image = cachedImage
            return
        }
        
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self else { return }
            guard self.currentImageURL == url else { return }
            
            if let error = error {
                print("Image download error: \(error.localizedDescription)")
                return
            }
            
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    ProductCollectionViewCell.imageCache[url] = image
                    if self.currentImageURL == url { 
                        self.imageView.image = image
                    }
                }
            }
        }.resume()
    }
}
