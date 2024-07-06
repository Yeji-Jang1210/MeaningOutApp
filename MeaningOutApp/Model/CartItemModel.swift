//
//  CartItemModel.swift
//  MeaningOutApp
//
//  Created by 장예지 on 7/5/24.
//

import Foundation
import RealmSwift

class CartItem: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var productId: String
    @Persisted var title: String
    @Persisted var price: Int
    @Persisted var mallName: String
    @Persisted var addedDate: Date
    @Persisted var image: String
    @Persisted var link: String
    
    func formattedPrice() -> String {
        return Product.formattedPrice(price)
    }
    
    convenience init(_ product: Product) {
        self.init()
        self.productId = product.productId
        self.title = product.removedHTMLTagTitle
        self.price = Int(product.lprice) ?? 0
        self.mallName = product.mallName
        self.addedDate = Date()
        self.image = product.image
        self.link = product.link
    }
}
