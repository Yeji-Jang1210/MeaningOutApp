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
        if let category = realm.objects(Category.self).first {
            try! realm.write {
                category.products.append(item)
            }
        }
    }
    
    func fetch() -> RealmSwift.Results<CartItem> {
        realm.objects(CartItem.self)
    }
    
    func deleteAll() {
        try! realm.write {
            realm.deleteAll()
        }
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

extension CartRepository {
    func fetchCategory() -> Results<Category> {
        return realm.objects(Category.self)
    }
    
    func createDefaultCategory(){
        let category = Category(name: Localized.category_allProducs.title, categoryDescription: Localized.category_allProducs.text)
        
        try! realm.write {
            realm.add(category)
        }
    }
}

protocol CartRepositoryProtocol {
    // Create
    func addItem(item: CartItem)
    
    // Read
    func fetch() -> Results<CartItem>
    
    // Delete
    func deleteItem(item: CartItem)
    func deleteItemForId(productId: String)
}

