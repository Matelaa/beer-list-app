//
//  BeerViewController.swift
//  beer-list
//
//  Created by Matela on 30/01/24.
//

import UIKit

class BeerViewController: UIViewController {
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.center = self.view.center
        activityIndicator.color = .gray
        activityIndicator.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        activityIndicator.startAnimating()
        
        return activityIndicator
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var typingTimer: Timer?
    
    var filteredText: String = ""
    
    let viewModel = BeerViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel.delegate = self
        
        self.setupUI()
        self.viewModel.teste()
    }
    
    private func setupLoadingScreen() {
        self.view.addSubview(self.activityIndicator)
        self.setupActivityIndicatorConstraints()
    }
    
    private func removeLoadingScreen() {
        DispatchQueue.main.async {
            self.activityIndicator.removeFromSuperview()
        }
    }
    
    private func setupUI() {
        self.title = "Beer List"
        
        self.view.addSubview(self.tableView)
        
        self.view.backgroundColor = UIColor.darkBlueCustom
        self.tableView.backgroundColor = .white
        
        self.setupConstraints()
        
        self.setupSearchController()
        self.setupTableView()
    }
    
    private func setupSearchController() {
        searchController.searchBar.delegate = self
        searchController.searchBar.searchTextField.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        
        searchController.searchBar.barStyle = .default
        searchController.searchBar.searchTextField.leftView?.tintColor = .black
        searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search users", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        
        navigationItem.searchController = searchController
        definesPresentationContext = true
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
    
    private func setupActivityIndicatorConstraints() {
        NSLayoutConstraint.activate([
            self.activityIndicator.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.activityIndicator.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.activityIndicator.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.activityIndicator.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
    }
    
    private func setupTableViewConstraints() {
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    private func filterUserForSeachText(user: String) {
        self.viewModel.searchBeers(searchText: user)
    }
}

extension BeerViewController: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.viewModel.resetSearch()
        self.tableView.reloadData()
        return true
    }
}

extension BeerViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.viewModel.resetSearch()
        self.reloadTableView()
    }
}

extension BeerViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        self.typingTimer?.invalidate()
        self.typingTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { _ in
            let searchBar = searchController.searchBar
            self.filteredText = searchBar.text!
            self.viewModel.resetSearch()
            self.viewModel.searchBeers(searchText: self.filteredText)
        })
    }
}

extension BeerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.isFiltering ? self.viewModel.filteredBeers.count : self.viewModel.beers.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! BeerTableViewCell
        
        if self.viewModel.isFiltering {
            cell.bind(beer: self.viewModel.filteredBeers[indexPath.item])
        } else {
            cell.bind(beer: self.viewModel.beers[indexPath.item])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.item)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastRowIndex = tableView.numberOfRows(inSection: 0) - 1
        if self.viewModel.isFiltering {
            if indexPath.row == lastRowIndex && self.viewModel.filteredBeers.count % 20 == 0 {
                self.viewModel.searchBeers(searchText: self.filteredText)
            }
        } else {
            if indexPath.row == lastRowIndex && self.viewModel.beers.count % 20 == 0 {
                print("final da lista")
                self.viewModel.teste()
            }
        }
    }
}

extension BeerViewController: BeerViewModelDelegate {
    func hasBeerFiltered(hasBeer: Bool) {
        if !hasBeer {
            print("tem n sinho")
        }
    }
    
    func finishedGetBeers() {
        if self.viewModel.isLoading {
            self.setupLoadingScreen()
        } else {
            self.removeLoadingScreen()
            self.reloadTableView()
        }
    }
}
