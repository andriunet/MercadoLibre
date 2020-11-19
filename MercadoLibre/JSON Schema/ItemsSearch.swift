//
//  ItemsSearch.swift
//  MercadoLibre
//
//  Created by Andres Marin on 17/11/20.
//

import Foundation

struct ItemsSearch: Codable {
    var site_id: String?
    var query: String?
    var results: [Results]
}

struct Results: Codable {
    var id: String
    var site_id: String
    var title: String
    var price: Double
    var condition: String
    var thumbnail: String
}


