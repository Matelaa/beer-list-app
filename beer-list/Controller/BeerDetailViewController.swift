//
//  BeerDetailViewController.swift
//  beer-list
//
//  Created by Matela on 31/01/24.
//

import UIKit
import Kingfisher

class BeerDetailViewController: UIViewController {
    
    lazy var beerImageView: UIImageView = {
        let image = UIImage()
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var beerNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = .darkGrayCustom
        label.numberOfLines = 0
        
        return label
    }()
    
    lazy var beerTaglineLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = .darkGrayCustom
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        return label
    }()
    
    lazy var beerDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = .lightGrayCustom
        label.numberOfLines = 0
        
        return label
    }()
    
    lazy var favoriteIconImageView: UIImageView = {
        let image = UIImage(named: "FavoriteIcon")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnFavoriteIcon))
        imageView.addGestureRecognizer(tapGesture)
        return imageView
    }()
    
    var beer: Beer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    private func setupUI() {
        self.view.backgroundColor = .white
        
        self.title = self.beer.name
        if let imageURLString = self.beer.image, let imageURL = URL(string: imageURLString) {
            self.beerImageView.kf.setImage(with: imageURL)
        } else {
            let beerPlaceholder = UIImage(named: "BeerPlaceholder")
            self.beerImageView.image = beerPlaceholder
        }
        self.beerNameLabel.text = self.beer.name
        self.beerTaglineLabel.text = self.beer.tagline
        self.beerDescriptionLabel.text = self.beer.description
        
        self.view.addSubview(self.beerImageView)
        self.view.addSubview(self.beerNameLabel)
        self.view.addSubview(self.beerTaglineLabel)
        self.view.addSubview(self.beerDescriptionLabel)
        self.view.addSubview(self.favoriteIconImageView)
        
        self.setupConstraints()
        
        self.checkBeerIsFavorited()
    }
    
    private func checkBeerIsFavorited() {
        if let savedFavorite = UserDefaults.standard.value(forKey: "favorite_\(self.beer.id)") as? Bool {
            self.beer.isFavorite = savedFavorite
            
            self.favoriteIconImageView.tintColor = self.beer.isFavorite ? .systemYellow : .black
        }
    }
    
    private func setupConstraints() {
        self.setupBeerImageViewConstraints()
        self.setupBeerNameLabelConstraints()
        self.setupBeerTaglineLabelConstraints()
        self.setupBeerDescriptionLabelConstraints()
        self.setupFavoriteIconImageViewConstraints()
    }
    
    private func setupBeerImageViewConstraints() {
        NSLayoutConstraint.activate([
            self.beerImageView.heightAnchor.constraint(equalToConstant: 74),
            self.beerImageView.widthAnchor.constraint(equalToConstant: 74),
            self.beerImageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 48),
            self.beerImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24)
        ])
        self.view.layoutIfNeeded()
        self.beerImageView.layer.masksToBounds = true
        self.beerImageView.layer.cornerRadius = self.beerImageView.frame.size.width / 2
    }
    
    private func setupBeerNameLabelConstraints() {
        NSLayoutConstraint.activate([
            self.beerNameLabel.topAnchor.constraint(equalTo: self.beerImageView.topAnchor, constant: 6),
            self.beerNameLabel.leftAnchor.constraint(equalTo: self.beerImageView.rightAnchor, constant: 12),
            self.beerNameLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24)
        ])
    }
    
    private func setupBeerTaglineLabelConstraints() {
        NSLayoutConstraint.activate([
            self.beerTaglineLabel.topAnchor.constraint(equalTo: self.beerNameLabel.bottomAnchor, constant: 12),
            self.beerTaglineLabel.leftAnchor.constraint(equalTo: self.beerImageView.rightAnchor, constant: 12),
            self.beerTaglineLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12)
        ])
    }
    
    private func setupBeerDescriptionLabelConstraints() {
        NSLayoutConstraint.activate([
            self.beerDescriptionLabel.topAnchor.constraint(equalTo: self.beerTaglineLabel.bottomAnchor, constant: 60),
            self.beerDescriptionLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24),
            self.beerDescriptionLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24)
        ])
    }
    
    private func setupFavoriteIconImageViewConstraints() {
        NSLayoutConstraint.activate([
            self.favoriteIconImageView.heightAnchor.constraint(equalToConstant: 40),
            self.favoriteIconImageView.widthAnchor.constraint(equalToConstant: 40),
            self.favoriteIconImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.favoriteIconImageView.topAnchor.constraint(equalTo: self.beerDescriptionLabel.bottomAnchor, constant: 24)
        ])
        self.favoriteIconImageView.tintColor = self.beer.isFavorite ? .systemYellow : .black
    }
    
    @objc private func tapOnFavoriteIcon() {
        self.beer.isFavorite.toggle()
        
        self.favoriteIconImageView.tintColor = self.beer.isFavorite ? .systemYellow : .black
        
        let favorites = UserDefaults.standard
        
        if self.beer.isFavorite {
            favorites.set(true, forKey: "favorite_\(beer.id)")
        } else {
            favorites.removeObject(forKey: "favorite_\(beer.id)")
        }
    }
}
