//
//  NoResultSearchView.swift
//  beer-list
//
//  Created by Matela on 01/02/24.
//

import UIKit

class NoResultSearchView: UIView {
    
    lazy var noResultImageView: UIImageView = {
        let image = UIImage(named: "NoResultsFound")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var noResultLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = .darkGrayCustom
        label.numberOfLines = 0
        label.textAlignment = .center
        
        label.text = "No results were found."
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.backgroundColor = .white
        
        self.addSubview(self.noResultImageView)
        self.addSubview(self.noResultLabel)
        
        self.setupNoResultImageViewConstraints()
        self.setupNoResultLabelConstraints()
    }
    
    private func setupNoResultImageViewConstraints() {
        NSLayoutConstraint.activate([
            self.noResultImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.noResultImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.noResultImageView.widthAnchor.constraint(equalToConstant: 200),
            self.noResultImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func setupNoResultLabelConstraints() {
        NSLayoutConstraint.activate([
            self.noResultLabel.topAnchor.constraint(equalTo: self.noResultImageView.bottomAnchor, constant: 12),
            self.noResultLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12),
            self.noResultLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12)
        ])
    }
}
