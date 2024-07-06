//
//  CartRepository.swift
//  MeaningOutApp
//
//  Created by 장예지 on 7/5/24.
//

import Foundation
import RealmSwift

final class CartRepository: CartRepositoryProtocol {
    
    private let realm = try! Realm()
    
    func addItem(item: CartItem) {
        try! realm.write {
            realm.add(item)
        }
    }
    
    func fetch() -> RealmSwift.Results<CartItem> {
        realm.objects(CartItem.self)
    }
    
    func deleteItem(item: CartItem) {
        try! realm.write {
            realm.delete(item)
        }
    }
    
    func deleteItemForId(productId: String) {
        let item = realm.objects(CartItem.self).where {
            $0.productId == productId
        }
        
        try! realm.write{
            realm.delete(item)
        }
    }
    
    func findProductId(productId: String) -> Bool{
        let item = realm.objects(CartItem.self).where {
            $0.productId == productId
        }
        
        return !item.isEmpty ? true : false
    }
}

protocol CartRepositoryProtocol {
    // Create
    func addItem(item: CartItem)
    
    // Read
    func fetch() -> Results<CartItem>
//    func fetchSort(_ sort: String) -> Results<CartItem>
//    func fetchFilter(_ filter: String) -> Results<CartItem>
    
    // Delete
    func deleteItem(item: CartItem)
    func deleteItemForId(productId: String)
}
