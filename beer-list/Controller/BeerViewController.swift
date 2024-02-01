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

    lazy var noResultsSearchView: NoResultSearchView = {
        let view = NoResultSearchView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        
        return view
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
    
    private func updateNoResultsImageView() {
        let hasResults = self.viewModel.isFiltering ? !self.viewModel.filteredBeers.isEmpty : !self.viewModel.beers.isEmpty
        DispatchQueue.main.async {
            self.noResultsSearchView.isHidden = hasResults
        }
    }
    
    private func createSearchButton() {
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonTapped))
        self.navigationItem.rightBarButtonItem = searchButton
    }
    
    @objc private func searchButtonTapped() {
        self.searchController.isActive = true
        self.searchController.searchBar.searchTextField.becomeFirstResponder()
    }
    
    private func createFavoritesButton() {
        let favoritesButton = UIBarButtonItem(title: "Favorites", style: .plain, target: self, action: #selector(favoritesButtonTapped))
        self.navigationItem.leftBarButtonItem = favoritesButton
    }
    
    @objc private func favoritesButtonTapped() {
        let favoritesViewController = BeerFavoriteViewController()
        self.navigationController?.pushViewController(favoritesViewController, animated: true)
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
        self.view.addSubview(self.noResultsSearchView)
        
        self.view.backgroundColor = UIColor.darkBlueCustom
        self.tableView.backgroundColor = .white
        
        self.setupConstraints()
        
        self.setupSearchController()
        self.createFavoritesButton()
        self.setupTableView()
    }
    
    private func setupSearchController() {
        self.createSearchButton()
        
        self.searchController.searchBar.delegate = self
        self.searchController.searchBar.searchTextField.delegate = self
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        
        self.searchController.searchBar.barStyle = .default
        self.searchController.searchBar.searchTextField.leftView?.tintColor = .white
        self.searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search users", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = true
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
        self.setupNoResultsImageViewConstraints()
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
    
    private func setupNoResultsImageViewConstraints() {
        NSLayoutConstraint.activate([
            self.noResultsSearchView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.noResultsSearchView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
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
        self.updateNoResultsImageView()
        self.reloadTableView()
        return true
    }
}

extension BeerViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.viewModel.resetSearch()
        self.updateNoResultsImageView()
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
        let beerDetailViewController = BeerDetailViewController()
        if self.viewModel.isFiltering {
            beerDetailViewController.beer = self.viewModel.filteredBeers[indexPath.item]
        } else {
            beerDetailViewController.beer = self.viewModel.beers[indexPath.item]
        }
        self.navigationController?.pushViewController(beerDetailViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastRowIndex = tableView.numberOfRows(inSection: 0) - 1
        if self.viewModel.isFiltering {
            if indexPath.row == lastRowIndex && self.viewModel.filteredBeers.count % 20 == 0 {
                self.viewModel.searchBeers(searchText: self.filteredText)
            }
        } else {
            if indexPath.row == lastRowIndex && self.viewModel.beers.count % 20 == 0 {
                self.viewModel.teste()
            }
        }
    }
}

extension BeerViewController: BeerViewModelDelegate {
    func hasBeerFiltered(hasBeer: Bool) {
        if !hasBeer {
            self.updateNoResultsImageView()
        }
    }
    
    func finishedGetBeers() {
        if self.viewModel.isLoading {
            self.setupLoadingScreen()
        } else {
            self.removeLoadingScreen()
            self.reloadTableView()
            self.updateNoResultsImageView()
        }
    }
}
