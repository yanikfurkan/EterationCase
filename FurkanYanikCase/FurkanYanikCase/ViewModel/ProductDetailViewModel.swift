//
//  ProductDetailViewModel.swift
//  FurkanYanikCase
//
//  Created by Furkan Yanık on 18.12.2024.
//

import Foundation

import Foundation

class ProductDetailViewModel {
    private let product: Product

    init(product: Product) {
        self.product = product
    }

    var productName: String { product.name }
    var productDescription: String { product.description }
    var productPrice: String { product.price }

    var productImageURL: URL? {
        return URL(string: product.image)
    }

    var isFavorite: Bool {
        return PersistenceManager.shared.isFavorite(product: product)
    }

    func toggleFavorite() {
        if isFavorite {
            if let favItem = PersistenceManager.shared.fetchFavoriteItems().first(where: {$0.id == product.id}) {
                PersistenceManager.shared.removeFavoriteItem(favItem)
            }
        } else {
            PersistenceManager.shared.addToFavorites(product: product)
        }
    }

    func addToCart() {
        PersistenceManager.shared.addToCart(product: product)
    }
}
