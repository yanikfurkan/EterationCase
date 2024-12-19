//
//  ProductListViewController.swift
//  FurkanYanikCase
//
//  Created by Furkan Yanık on 18.12.2024.
//

import UIKit

class ProductListViewController: BaseViewController {
    private let searchBar = UISearchBar()
    private let filtersLabel = UILabel()
    private let filterButton = UIButton()
    private let collectionView: UICollectionView
    private let viewModel = ProductListViewModel()

    init() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isHidden = true

        setupUI()
        bindViewModel()
        viewModel.loadProducts()
    }

    func setupUI() {
        searchBar.delegate = self
        searchBar.placeholder = "Search"
        contentView.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false

        filtersLabel.text = "Filters:"
        filtersLabel.font = UIFont.systemFont(ofSize: 14)
        filtersLabel.textColor = .black
        contentView.addSubview(filtersLabel)
        filtersLabel.translatesAutoresizingMaskIntoConstraints = false

        filterButton.setTitle("Select Filter", for: .normal)
        filterButton.setTitleColor(.black, for: .normal)
        filterButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        filterButton.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        filterButton.addTarget(self, action: #selector(didTapFilter), for: .touchUpInside)
        contentView.addSubview(filterButton)
        filterButton.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(collectionView)
        collectionView.backgroundColor = .white
        collectionView.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: "ProductCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            searchBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14),
            searchBar.heightAnchor.constraint(equalToConstant: 40),

            
            filtersLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 19),
            filtersLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            
            filterButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 14),
            filterButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -17),
            filterButton.widthAnchor.constraint(equalToConstant: 158),
            filterButton.heightAnchor.constraint(equalToConstant: 36),

            collectionView.topAnchor.constraint(equalTo: filtersLabel.bottomAnchor, constant: 24),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    func bindViewModel() {
        viewModel.onDataUpdated = { [weak self] in
            self?.collectionView.reloadData()
        }
        viewModel.onError = { error in
            print("Error: \(error)")
        }
    }

    @objc func didTapFilter() {
        let filterVC = FilterViewController()
        filterVC.modalPresentationStyle = .formSheet
        filterVC.onApplyFilters = { [weak self] filters in
            self?.viewModel.selectedFilters = filters
        }
        present(filterVC, animated: true, completion: nil)
    }
}


extension ProductListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchQuery = searchText
    }
}

extension ProductListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCollectionViewCell
        let product = viewModel.product(at: indexPath.row)
        cell.configure(with: product)
        cell.onAddToCart = {
            PersistenceManager.shared.addToCart(product: product)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = viewModel.product(at: indexPath.row)
        let detailVM = ProductDetailViewModel(product: product)
        let detailVC = ProductDetailViewController(viewModel: detailVM)
        navigationController?.pushViewController(detailVC, animated: true)
    }


    // Infinite scroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.height * 2 {
            viewModel.loadProducts()
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 21) / 2
        return CGSize(width: width, height: 302)
    }
}
