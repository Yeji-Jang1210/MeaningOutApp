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
    
    func deleteAll(completion: @escaping ((Bool) -> Void)) {
        do {
            try realm.write{
                realm.deleteAll()
                completion(true)
            }
        } catch {
            completion(false)
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
        
        createCategory(category)
    }
    
    func createCategory(_ category: Category){
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error")
        }
    }
    
    func createProductInCategory(categoryIndex: Int?, product: Product){
        let list = fetchCategory()
        let cartItem = CartItem(product)
        
        do {
            try realm.write {
                if let index = categoryIndex, index < list.count {
                    list[index].products.append(cartItem)
                }
                
                // 0번 인덱스에도 제품 추가
                if list.count > 0 {
                    list[0].products.append(cartItem)
                }
            }
        } catch {
            print(error)
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

