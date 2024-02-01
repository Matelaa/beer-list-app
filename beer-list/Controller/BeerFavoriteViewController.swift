//
//  BeerFavoriteViewController.swift
//  beer-list
//
//  Created by Matela on 31/01/24.
//

import UIKit

class BeerFavoriteViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let viewModel = BeerFavoriteViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel.delegate = self
        
        self.viewModel.getFavoriteBeers()
        
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewModel.getFavoriteBeers()
        self.reloadTableView()
    }
    
    private func setupUI() {
        self.title = "Favorited Beers"
        
        self.view.addSubview(self.tableView)
        
        self.view.backgroundColor = UIColor.darkBlueCustom
        self.tableView.backgroundColor = .white
        
        self.setupConstraints()
        
        self.setupTableView()
    }
    
    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(BeerTableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.separatorStyle = .none
    }
    
    private func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func setupConstraints() {
        self.setupTableViewConstraints()
    }
    
    private func setupTableViewConstraints() {
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
}

extension BeerFavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.favoritedBeers.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! BeerTableViewCell
        
        cell.bind(beer: self.viewModel.favoritedBeers[indexPath.item])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let beerDetailViewController = BeerDetailViewController()
        
        beerDetailViewController.beer = self.viewModel.favoritedBeers[indexPath.item]
        
        self.navigationController?.pushViewController(beerDetailViewController, animated: true)
    }
}

extension BeerFavoriteViewController: BeerFavoriteViewModelDelegate {
    func finishedGetFavoritedBeers() {
        self.reloadTableView()
    }
}
