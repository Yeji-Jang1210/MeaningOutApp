//
//  CartCategoryViewModel.swift
//  MeaningOutApp
//
//  Created by 장예지 on 7/13/24.
//

import Foundation
import RealmSwift

final class CartCategoryViewModel {
    let repository = CartRepository()
    
    var inputDidSelectItemIndex: Observable<Int?> = Observable(nil)
    var inputAddCategoryButtonTappedTrigger: Observable<Void?> = Observable(nil)
    
    lazy var outputCategoryList: Observable<Results<Category>> = Observable(repository.fetchCategory())
    var outputPresentProductListForCategory: Observable<(Category?, Results<CartItem>?)> = Observable((nil,nil))
    var outputPresentAddCategoryVC: Observable<Void?> = Observable(nil)
    init(){
        bind()
    }
    
    private func bind(){
        inputDidSelectItemIndex.bind { index in
            guard let index else { return }
            
            let list = self.repository.fetch().where {
                $0.category.name == self.outputCategoryList.value[index].name
            }
            
            self.outputPresentProductListForCategory.value = (self.outputCategoryList.value[index], list)
        }
        
        inputAddCategoryButtonTappedTrigger.bind { trigger in
            guard let trigger else { return }
            self.outputPresentAddCategoryVC.value = ()
        }
    }
}
