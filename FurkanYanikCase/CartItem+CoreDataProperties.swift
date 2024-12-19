//
//  CartItem+CoreDataProperties.swift
//  FurkanYanikCase
//
//  Created by Furkan Yanık on 18.12.2024.
//
//

import Foundation
import CoreData


extension CartItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CartItem> {
        return NSFetchRequest<CartItem>(entityName: "CartItem")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var price: String?
    @NSManaged public var quantity: Int16
    @NSManaged public var imageURL: String?

}

extension CartItem : Identifiable {

}
