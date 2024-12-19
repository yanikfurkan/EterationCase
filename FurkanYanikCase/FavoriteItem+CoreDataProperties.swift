//
//  FavoriteItem+CoreDataProperties.swift
//  FurkanYanikCase
//
//  Created by Furkan Yanik on 19.12.2024.
//
//

import Foundation
import CoreData


extension FavoriteItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteItem> {
        return NSFetchRequest<FavoriteItem>(entityName: "FavoriteItem")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var price: String?
    @NSManaged public var imageURL: String?

}

extension FavoriteItem : Identifiable {

}
