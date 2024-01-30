//
//  BeerViewController.swift
//  beer-list
//
//  Created by Matela on 30/01/24.
//

import UIKit

class BeerViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let viewModel = BeerViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel.delegate = self
        
        self.setupUI()
        self.viewModel.teste()
        print(self.viewModel.beers)
    }
    
    private func setupUI() {
        self.title = "Beer List"
        
        self.view.backgroundColor = UIColor.darkBlueCustom

        self.view.addSubview(self.tableView)
        
        self.tableView.backgroundColor = .white
        
        self.setupConstraints()
        self.setupTableView()
    }
    
    private func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(BeerTableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.separatorStyle = .none
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

extension BeerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.beers.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! BeerTableViewCell
        
        cell.bind(beer: self.viewModel.beers[indexPath.item])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.item)
    }
}

extension BeerViewController: BeerViewModelDelegate {
    func finishedGetBeers() {
        print(self.viewModel.beers)
        self.reloadTableView()
    }
}
