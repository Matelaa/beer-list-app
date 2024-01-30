//
//  Beer.swift
//  beer-list
//
//  Created by Matela on 30/01/24.
//

import Foundation

struct Beer: Codable {
    let id: Int
    let name: String
    let tagline: String
    let description: String
    let image: String
    var isFavorite: Bool
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.tagline = try container.decode(String.self, forKey: .tagline)
        self.description = try container.decode(String.self, forKey: .description)
        self.image = try container.decode(String.self, forKey: CodingKeys.image)
        self.isFavorite = false
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, tagline, description, isFavorite
        case image = "image_url"
    }
}
