//
//  BaseViewController.swift
//  FurkanYanikCase
//
//  Created by Furkan Yanik on 19.12.2024.
//

import UIKit

class BaseViewController: UIViewController {
    let headerView = UIView()
    let footerView = UIView()
    let contentView = UIView()

    private let headerHeight: CGFloat = 49
    private let footerHeight: CGFloat = 60

    let homeButton = UIButton(type: .system)
    let cartButton = UIButton(type: .system)
    let favoriteButton = UIButton(type: .system)
    let profileButton = UIButton(type: .system)

    private let cartBadgeLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupHeader()
        setupFooter()
        setupContentView()
        setupFooterButtons()
        
        NotificationCenter.default.addObserver(self, selector: #selector(cartDidUpdate), name: .cartUpdated, object: nil)
    }

    private func setupHeader() {
        headerView.backgroundColor = .systemBlue
        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: headerHeight)
        ])

        let titleLabel = UILabel()
        titleLabel.text = "E-Market"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        headerView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16)
        ])
    }

    private func setupFooter() {
        footerView.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        view.addSubview(footerView)
        footerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            footerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerView.heightAnchor.constraint(equalToConstant: footerHeight)
        ])
    }

    private func setupContentView() {
        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: footerView.topAnchor)
        ])
    }

    private func setupFooterButtons() {
        // Örnek ikonlar
        homeButton.setImage(UIImage(systemName: "house"), for: .normal)
        cartButton.setImage(UIImage(systemName: "cart"), for: .normal)
        favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        profileButton.setImage(UIImage(systemName: "person"), for: .normal)

        homeButton.translatesAutoresizingMaskIntoConstraints = false
        cartButton.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        profileButton.translatesAutoresizingMaskIntoConstraints = false
        
        homeButton.tintColor = UIColor.black
        cartButton.tintColor = UIColor.black
        favoriteButton.tintColor = UIColor.black
        profileButton.tintColor = UIColor.black

        let stackView = UIStackView(arrangedSubviews: [homeButton, cartButton, favoriteButton, profileButton])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing

        footerView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -16),
            stackView.centerYAnchor.constraint(equalTo: footerView.centerYAnchor)
        ])

        [homeButton, cartButton, favoriteButton, profileButton].forEach { btn in
            btn.widthAnchor.constraint(equalToConstant: 33).isActive = true
            btn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        }

        homeButton.addTarget(self, action: #selector(didTapHome), for: .touchUpInside)
        cartButton.addTarget(self, action: #selector(didTapCart), for: .touchUpInside)
        favoriteButton.addTarget(self, action: #selector(didTapFavorites), for: .touchUpInside)

        
        cartBadgeLabel.backgroundColor = .red
        cartBadgeLabel.textColor = .white
        cartBadgeLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        cartBadgeLabel.textAlignment = .center
        cartBadgeLabel.layer.cornerRadius = 10
        cartBadgeLabel.clipsToBounds = true
        cartBadgeLabel.isHidden = true // Başta gizli
        cartButton.addSubview(cartBadgeLabel)
        cartBadgeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cartBadgeLabel.topAnchor.constraint(equalTo: cartButton.topAnchor, constant: -5),
            cartBadgeLabel.trailingAnchor.constraint(equalTo: cartButton.trailingAnchor, constant: 5),
            cartBadgeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 20),
            cartBadgeLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    
    func updateCartBadge(count: Int) {
        if count > 0 {
            cartBadgeLabel.isHidden = false
            cartBadgeLabel.text = "\(count)"
        } else {
            cartBadgeLabel.isHidden = true
        }
    }
    
    @objc func cartDidUpdate() {
        let count = PersistenceManager.shared.fetchCartItems().count
        updateCartBadge(count: count)
    }

    @objc func didTapHome() {
        if let nav = navigationController {
            nav.popToRootViewController(animated: true)
        }
    }

    @objc func didTapCart() {
        let cartVC = CartViewController()
        if let nav = navigationController {
            nav.pushViewController(cartVC, animated: true)
        } else {
            present(UINavigationController(rootViewController: cartVC), animated: true)
        }
    }
    
    @objc func didTapFavorites() {
        let favoriteVC = FavoriteViewController()
        navigationController?.pushViewController(favoriteVC, animated: true)
    }

}
