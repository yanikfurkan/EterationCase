//
//  NetworkManager.swift
//  FurkanYanikCase
//
//  Created by Furkan Yanık on 18.12.2024.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    func fetchProducts(page: Int, filters: [String:Any]?, searchQuery: String?, completion: @escaping (Result<[Product], Error>) -> Void) {
        var urlString = "https://5fc9346b2af77700165ae514.mockapi.io/products?page=\(page)&limit=4"

        if let filters = filters {
            if let brand = filters["brand"] as? String, !brand.isEmpty {
                urlString += "&brand=\(brand)"
            }
            if let model = filters["model"] as? String, !model.isEmpty {
                urlString += "&model=\(model)"
            }
        }

        if let query = searchQuery, !query.isEmpty {
            urlString += "&search=\(query)"
        }

        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }

            do {
                let products = try JSONDecoder().decode([Product].self, from: data)
                completion(.success(products))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }



}

enum NetworkError: Error {
    case invalidURL
    case noData
}
