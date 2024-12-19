//
//  Product.swift
//  FurkanYanikCase
//
//  Created by Furkan Yanık on 18.12.2024.
//

import Foundation

struct Product: Decodable {
    let id: String
    let name: String
    let image: String
    let price: String
    let description: String
    let model: String
    let brand: String
}
