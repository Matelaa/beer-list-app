//
//  BeerTableViewCell.swift
//  beer-list
//
//  Created by Matela on 30/01/24.
//

import UIKit
import Kingfisher

class BeerTableViewCell: UITableViewCell {
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        
        return label
    }()
    
    lazy var beerTaglineLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = .lightGrayCustom
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        
        return label
    }()
    
    lazy var arrowIconImageView: UIImageView = {
        let image = UIImage(named: "ArrowIcon")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .lightGrayCustom
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var beer: Beer!
    
    func bind(beer: Beer) {
        self.beer = beer
        //setup kingfisher to image of beer, pass this to VIEWMODEL
        if let imageURLString = self.beer.image, let imageURL = URL(string: imageURLString) {
            self.beerImageView.kf.setImage(with: imageURL)
        } else {
            let beerPlaceholder = UIImage(named: "BeerPlaceholder")
            self.beerImageView.image = beerPlaceholder
        }
        self.beerNameLabel.text = self.beer.name
        self.beerTaglineLabel.text = self.beer.tagline
    }
    
    private func setupCornerRadiusInCell() {
        self.clipsToBounds = true
        self.containerView.layer.cornerRadius = 10
    }
    
    private func setupUI() {
        self.backgroundColor = .white
        
        self.setupCornerRadiusInCell()
        
        self.addSubview(self.containerView)
        
        self.containerView.addSubview(self.beerImageView)
        self.containerView.addSubview(self.arrowIconImageView)
        self.containerView.addSubview(self.beerNameLabel)
        self.containerView.addSubview(self.beerTaglineLabel)
        
        self.setupConstraints()
    }
    
    private func setupConstraints() {
        self.setupContainerViewConstraints()
        self.setupBeerImageViewConstraints()
        self.setupBeerNameLabelConstraints()
        self.setupBeerTaglineLabelConstraints()
        self.setupArrowIconImageViewConstraints()
    }
    
    private func setupContainerViewConstraints() {
        NSLayoutConstraint.activate([
            self.containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            self.containerView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            self.containerView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
            self.containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
        ])
        
        self.containerView.backgroundColor = .backgroundLightGrayCustom
    }
    
    private func setupBeerImageViewConstraints() {
        NSLayoutConstraint.activate([
            self.beerImageView.heightAnchor.constraint(equalToConstant: 60),
            self.beerImageView.widthAnchor.constraint(equalToConstant: 60),
            self.beerImageView.centerYAnchor.constraint(equalTo: self.containerView.centerYAnchor),
            self.beerImageView.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: 12)
        ])
        
        self.layoutIfNeeded()
        self.beerImageView.layer.masksToBounds = true
        self.beerImageView.layer.cornerRadius = self.beerImageView.frame.size.width / 2
    }
    
    private func setupBeerNameLabelConstraints() {
        NSLayoutConstraint.activate([
            self.beerNameLabel.topAnchor.constraint(equalTo: self.beerImageView.topAnchor, constant: 6),
            self.beerNameLabel.leftAnchor.constraint(equalTo: self.beerImageView.rightAnchor, constant: 12),
            self.beerNameLabel.rightAnchor.constraint(equalTo: self.arrowIconImageView.leftAnchor, constant: -24)
        ])
    }
    
    private func setupBeerTaglineLabelConstraints() {
        NSLayoutConstraint.activate([
            self.beerTaglineLabel.topAnchor.constraint(equalTo: self.beerNameLabel.bottomAnchor, constant: 6),
            self.beerTaglineLabel.leftAnchor.constraint(equalTo: self.beerImageView.rightAnchor, constant: 12),
            self.beerTaglineLabel.rightAnchor.constraint(equalTo: self.arrowIconImageView.leftAnchor, constant: -24)
        ])
    }
    
    private func setupArrowIconImageViewConstraints() {
        NSLayoutConstraint.activate([
            self.arrowIconImageView.heightAnchor.constraint(equalToConstant: 16),
            self.arrowIconImageView.widthAnchor.constraint(equalToConstant: 16),
            self.arrowIconImageView.centerYAnchor.constraint(equalTo: self.containerView.centerYAnchor),
            self.arrowIconImageView.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -8)
        ])
    }
}
