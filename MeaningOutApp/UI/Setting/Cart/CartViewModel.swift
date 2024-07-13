//
//  CartViewModel.swift
//  MeaningOutApp
//
//  Created by 장예지 on 7/14/24.
//

import Foundation
import RealmSwift

final class CartViewModel {
    let repository = CartRepository()
    var list: Results<CartItem>?
    
    var inputPassLikeButtonSenderTag: Observable<Int?> = Observable(nil)
    var inputSearchText: Observable<String?> = Observable(nil)
    
    var outputCartItemFilteredList: Observable<Results<CartItem>?> = Observable(nil)
    var outputCartItemIsDeleted: Observable<Bool?> = Observable(nil)
    
    init(list: Results<CartItem>){
        self.list = list
        self.outputCartItemFilteredList.value = self.list
        bind()
    }
    
    private func bind(){
        inputPassLikeButtonSenderTag.bind { index in
            guard let index = index, let list = self.outputCartItemFilteredList.value else { return }
            self.repository.deleteItem(item: list[index])
            self.outputCartItemIsDeleted.value = true
        }
        
        inputSearchText.bind { text in
            guard let text else { return }
            
            let filtered = self.outputCartItemFilteredList.value?.where {
                $0.title.contains(text, options: .caseInsensitive)
            }
            
            self.outputCartItemFilteredList.value = text.isEmpty ? self.list : filtered
        }
    }
    
    public func findProductId(_ id: String) -> Bool{
        return repository.findProductId(productId: id)
    }
}
