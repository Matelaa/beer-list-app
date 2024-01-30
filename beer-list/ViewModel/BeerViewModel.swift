//
//  BeerViewModel.swift
//  beer-list
//
//  Created by Matela on 30/01/24.
//

import Foundation

protocol BeerViewModelDelegate: AnyObject {
    func finishedGetBeers()
}

class BeerViewModel {
    weak var delegate: BeerViewModelDelegate?
    let service = BeerService()
    var beers = [Beer]()
    var page: Int = 1
    
    func teste() {
        self.service.getBeers(page: self.page) { beers in
            self.beers = beers
            self.delegate?.finishedGetBeers()
        }
    }
}
