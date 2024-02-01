//
//  BeerFavoriteViewModel.swift
//  beer-list
//
//  Created by Matela on 01/02/24.
//

import Foundation

protocol BeerFavoriteViewModelDelegate: AnyObject {
    func finishedGetFavoritedBeers()
}

class BeerFavoriteViewModel {
    
    weak var delegate: BeerFavoriteViewModelDelegate?
    let service = BeerService()
    var favoritedBeers: [Beer] = []
    
    func getFavoriteBeers() {
        var beers: [Beer] = []
        let defaults = UserDefaults.standard
        self.favoritedBeers = []
        
        for (key, value) in defaults.dictionaryRepresentation() {
            if key.hasPrefix("favorite_"), let beerStringID = key.split(separator: "_").last, let isFavorite = value as? Bool, isFavorite {
                if let beerID = Int(beerStringID) {
                    self.getBeerDetails(for: beerID) { beer in
                        if let beer = beer {
                            beers.append(beer)
                            self.favoritedBeers = beers
                            self.delegate?.finishedGetFavoritedBeers()
                        } else {
                            print("Erro ao obter detalhes da cerveja favorita")
                        }
                    }
                }
            }
        }
    }
    
    private func getBeerDetails(for beerID: Int, completion: @escaping (Beer?) -> Void) {
        self.service.getDetailBeerByID(id: beerID) { beer in
            completion(beer?.first)
        }
    }
}
