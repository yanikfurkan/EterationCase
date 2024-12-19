import UIKit

class FavoriteViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private let viewModel = FavoriteViewModel()
    private var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(onFavoritesUpdated), name: .favoritesUpdated, object: nil)
        
        setupCollectionView()
        setupBindings()
        viewModel.loadFavorites()
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        layout.itemSize = CGSize(width: 150, height: 250) // Hücre boyutları

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: "ProductCell")
        collectionView.backgroundColor = .white
        contentView.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    private func setupBindings() {
        viewModel.onDataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    @objc private func onFavoritesUpdated() {
        viewModel.loadFavorites()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCollectionViewCell
        let product = viewModel.item(at: indexPath.row)
        cell.configure(with: product)
        return cell
    }

    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 48) / 2, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedProduct = viewModel.item(at: indexPath.row)
        let detailViewModel = ProductDetailViewModel(product: selectedProduct)
        let detailVC = ProductDetailViewController(viewModel: detailViewModel)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
