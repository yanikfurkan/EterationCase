//
//  ProductListViewModel.swift
//  FurkanYanikCase
//
//  Created by Furkan Yanık on 18.12.2024.
//

import UIKit

class ProductListViewModel {
    private var products: [Product] = []
    private var currentPage: Int = 1
    var isLoading = false
    var hasMoreData = true

    var searchQuery: String? {
        didSet {
            loadProducts(reset: true)
        }
    }

    var selectedFilters: [String:Any]? {
        didSet {
            loadProducts(reset: true)
        }
    }

    var onDataUpdated: (() -> Void)?
    var onError: ((Error) -> Void)?

    func loadProducts(reset: Bool = false) {
        if reset {
            products = []
            currentPage = 1
            hasMoreData = true
        }

        guard hasMoreData, !isLoading else { return }
        isLoading = true

        NetworkManager.shared.fetchProducts(page: currentPage, filters: selectedFilters, searchQuery: searchQuery) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                switch result {
                case .success(let newProducts):
                    if newProducts.isEmpty {
                        self.hasMoreData = false
                    } else {
                        self.products.append(contentsOf: newProducts)
                        self.currentPage += 1
                    }
                    self.onDataUpdated?()
                case .failure(let error):
                    self.onError?(error)
                }
            }
        }
    }

    func numberOfItems() -> Int {
        return products.count
    }

    func product(at index: Int) -> Product {
        return products[index]
    }
}
