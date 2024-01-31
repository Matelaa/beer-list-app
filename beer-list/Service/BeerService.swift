//
//  BeerService.swift
//  beer-list
//
//  Created by Matela on 30/01/24.
//

import Foundation

class BeerService {
    
    func getBeers(page: Int, completion: @escaping ([Beer]) -> Void) {
        let baseURL: String = "https://api.punkapi.com/v2/beers?page=\(page)&per_page=20"
        let url = URL(string: baseURL)
        if let url = url {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    if let beers = try? JSONDecoder().decode([Beer].self, from: data) {
                        completion(beers)
                    } else {
                        print(data.description.localizedLowercase)
                    }
                } else {
                    print("Erro: \(String(describing: error))")
                }
            }
            task.resume()
        }
    }
    
    func searchBeers(page: Int, beer: String, completion: @escaping ([Beer]) -> ()) {
        let baseURL: String = "https://api.punkapi.com/v2/beers?page=\(page)&per_page=20&beer_name=\(beer)"
        let url = URL(string: baseURL)
        if let url = url {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    if let beers = try? JSONDecoder().decode([Beer].self, from: data) {
                        completion(beers)
                    } else {
                        print(data.description.localizedLowercase)
                    }
                } else {
                    print("Erro: \(String(describing: error))")
                }
            }
            task.resume()
        }
    }
}
