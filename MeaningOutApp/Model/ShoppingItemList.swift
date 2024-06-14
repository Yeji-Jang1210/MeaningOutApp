//
//  ShoppingItemList.swift
//  MeaningOutApp
//
//  Created by 장예지 on 6/14/24.
//

import Foundation

struct ShoppingItemList: Codable {
    let total: Int
    let start: Int
    let display: Int
    let items: [Item]
}

// MARK: - Item
struct Item: Codable {
    let title: String
    let link: String
    let image: String
    let lprice: String
    let mallName: String
    
    var removedHTMLTagTitle: String {
        return title.removingHTMLTags()
        
    }
    var priceStr: String {
        guard let price = Int(lprice) else { return "" }
        return "\(price.formatted())원"
    }
}
