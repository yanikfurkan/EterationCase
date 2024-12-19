//
//  PersistenceManager.swift
//  FurkanYanikCase
//
//  Created by Furkan Yanık on 18.12.2024.
//

import Foundation
import CoreData

class PersistenceManager {
    static let shared = PersistenceManager()

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CaseApp")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("CoreData error: \(error)")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    private init() {}

    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Core Data Save Error: \(error)")
            }
        }
    }

    func addToFavorites(product: Product) {
        guard fetchFavoriteItem(by: product.id) == nil else {
            print("Bu ürün zaten favorilerde: \(product.name)")
            return
        }

        let favoriteItem = FavoriteItem(context: context)
        favoriteItem.id = product.id
        favoriteItem.name = product.name
        favoriteItem.price = product.price
        favoriteItem.imageURL = product.image
        saveContext()

        NotificationCenter.default.post(name: .favoritesUpdated, object: nil)
        print("Favorilere eklendi: \(product.name)")
    }



    func fetchFavoriteItems() -> [FavoriteItem] {
        let request: NSFetchRequest<FavoriteItem> = FavoriteItem.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Fetch favorite error: \(error)")
            return []
        }
    }

    func fetchFavoriteItem(by id: String) -> FavoriteItem? {
        let request: NSFetchRequest<FavoriteItem> = FavoriteItem.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        do {
            let result = try context.fetch(request)
            return result.first
        } catch {
            print("Fetch favorite item error: \(error)")
            return nil
        }
    }

    func removeFavoriteItem(_ item: FavoriteItem) {
        context.delete(item)
        saveContext()
        NotificationCenter.default.post(name: .favoritesUpdated, object: nil)
    }

    func isFavorite(product: Product) -> Bool {
        return fetchFavoriteItem(by: product.id) != nil
    }

    func addToCart(product: Product) {
        print("Attempting to add product to cart: \(product.name)")

        guard let entityDescription = NSEntityDescription.entity(forEntityName: "CartItem", in: context) else {
            fatalError("Entity description for 'CartItem' not found.")
        }

        print("Entity description found for 'CartItem'.")

        if let cartItem = fetchCartItem(by: product.id) {
            cartItem.quantity += 1
            print("Updated quantity for product: \(product.name)")
        } else {
            let item = CartItem(entity: entityDescription, insertInto: context)
            item.id = product.id
            item.name = product.name
            item.price = product.price
            item.quantity = 1
            item.imageURL = product.image
            print("Created new cart item for product: \(product.name)")
        }

        saveContext()
        NotificationCenter.default.post(name: .cartUpdated, object: nil)
    }




    func fetchCartItems() -> [CartItem] {
        let request: NSFetchRequest<CartItem> = CartItem.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Fetch cart error: \(error)")
            return []
        }
    }

    func fetchCartItem(by id: String) -> CartItem? {
        let request: NSFetchRequest<CartItem> = CartItem.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        do {
            return try context.fetch(request).first
        } catch {
            print("Fetch cart item error: \(error)")
            return nil
        }
    }

    func updateCartItem(_ item: CartItem, quantity: Int) {
        item.quantity = Int16(quantity)
        if quantity <= 0 {
            context.delete(item)
        }
        saveContext()
        NotificationCenter.default.post(name: .cartUpdated, object: nil)
    }

    func removeCartItem(_ item: CartItem) {
        context.delete(item)
        saveContext()
        NotificationCenter.default.post(name: .cartUpdated, object: nil)
    }
}
