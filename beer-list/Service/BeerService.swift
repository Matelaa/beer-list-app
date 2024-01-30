//
//  BeerService.swift
//  beer-list
//
//  Created by Matela on 30/01/24.
//

import Foundation

class BeerService {
    let baseURL: String = "https://api.punkapi.com/v2/beers?page="
    
    func getBeers(page: Int, completion: @escaping ([Beer]) -> Void) {
        let url = URL(string: "\(self.baseURL)\(page)")
        if let url = url {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    if let beers = try? JSONDecoder().decode([Beer].self, from: data) {
                        completion(beers)
                    } else {
                        print("Erro ao decodificar os dados.")
                    }
                } else {
                    print("Erro: \(String(describing: error))")
                }
            }
            task.resume()
        }
    }
}
