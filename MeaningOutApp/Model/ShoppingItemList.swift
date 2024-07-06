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
    var items: [Product]
}

// MARK: - Item
struct Product: Codable {
    let title: String
    let link: String
    let image: String
    let lprice: String
    let productId: String
    let mallName: String
    
    var removedHTMLTagTitle: String {
        return title.removingHTMLTags()
        
    }
    
    var priceStr: String {
        return Product.formattedPrice(lprice)
    }
    
    static func formattedPrice(_ price: String) -> String {
        guard let price = Int(price) else { return "" }
        return "\(price.formatted())원"
    }
    
    static func formattedPrice(_ price: Int) -> String {
        return "\(price.formatted())"
    }
}
