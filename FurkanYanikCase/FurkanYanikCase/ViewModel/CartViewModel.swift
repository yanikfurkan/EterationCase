//
//  CartViewModel.swift
//  FurkanYanikCase
//
//  Created by Furkan Yanık on 18.12.2024.
//

import Foundation
import CoreData

class CartViewModel {
    private var items: [CartItem] = []
    var onDataUpdated: (() -> Void)?
    
    func loadCart() {
        items = PersistenceManager.shared.fetchCartItems()
        onDataUpdated?()
    }
    
    func numberOfRows() -> Int {
        return items.count
    }
    
    func item(at index: Int) -> CartItem {
        return items[index]
    }
    
    func incrementQuantity(at index: Int) {
        let item = items[index]
        let newQuantity = Int(item.quantity) + 1
        PersistenceManager.shared.updateCartItem(item, quantity: newQuantity)
        loadCart()
    }
    
    func decrementQuantity(at index: Int) {
        let item = items[index]
        let newQuantity = Int(item.quantity) - 1
        if newQuantity > 0 {
            PersistenceManager.shared.updateCartItem(item, quantity: newQuantity)
        } else {
            PersistenceManager.shared.removeCartItem(item)
        }
        loadCart()
    }
    
    func totalCost() -> String {
        var total: Double = 0
        for item in items {
            if let priceString = item.price, let priceVal = Double(priceString.replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "₺", with: "")) {
                total += priceVal * Double(item.quantity)
            }
        }
        return "\(total) ₺"
    }
}
