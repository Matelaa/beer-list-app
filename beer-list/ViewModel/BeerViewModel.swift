//
//  BeerViewModel.swift
//  beer-list
//
//  Created by Matela on 30/01/24.
//

import Foundation

protocol BeerViewModelDelegate: AnyObject {
    func finishedGetBeers()
    func hasBeerFiltered(hasBeer: Bool)
}

class BeerViewModel {
    weak var delegate: BeerViewModelDelegate?
    let service = BeerService()
    var beers = [Beer]()
    var isLoading: Bool = false
    var isFiltering: Bool = false
    var pageFilteredBeers: Int = 1
    var filteredBeers = [Beer]()
    var page: Int = 1
    var noBeerFound: Bool = false
    
    func teste() {
        self.isLoading = true
        self.delegate?.finishedGetBeers()
        self.service.getBeers(page: self.page) { [weak self] beers in
            self?.page += 1
            self?.beers.append(contentsOf: beers)
            self?.isLoading = false
            self?.delegate?.finishedGetBeers()
        }
    }
    
    func searchBeers(searchText: String) {
        if searchText.isEmpty {
            self.filteredBeers = []
            return
        }
        self.pageFilteredBeers += 1
        self.isLoading = true
        self.isFiltering = true
        self.noBeerFound = false
        self.delegate?.finishedGetBeers()
        self.service.searchBeers(page: self.pageFilteredBeers, beer: searchText) { [weak self] beers in
            if beers.isEmpty {
                self?.isLoading = false
                self?.noBeerFound = true
                self?.delegate?.hasBeerFiltered(hasBeer: !self!.noBeerFound)
                self?.delegate?.finishedGetBeers()
            } else {
                self?.isLoading = false
                self?.filteredBeers.append(contentsOf: beers)
                self?.delegate?.finishedGetBeers()
            }
        }
    }
    
    func resetSearch() {
        self.pageFilteredBeers = 0
        self.isFiltering = false
        self.filteredBeers = []
    }
}
