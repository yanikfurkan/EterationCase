//
//  FavoriteViewModel.swift
//  FurkanYanikCase
//
//  Created by Furkan Yanik on 19.12.2024.
//

import Foundation
import CoreData

class FavoriteViewModel {
    private var favorites: [FavoriteItem] = []
    var onDataUpdated: (() -> Void)?

    func loadFavorites() {
        favorites = PersistenceManager.shared.fetchFavoriteItems()
        onDataUpdated?()
    }

    func numberOfItems() -> Int {
        return favorites.count
    }

    func item(at index: Int) -> Product {
        let favoriteItem = favorites[index]
        return Product(
            id: favoriteItem.id ?? "",
            name: favoriteItem.name ?? "",
            image: favoriteItem.imageURL ?? "",
            price: favoriteItem.price ?? "",
            description: "",
            model: "",
            brand: ""
        )
    }
}
