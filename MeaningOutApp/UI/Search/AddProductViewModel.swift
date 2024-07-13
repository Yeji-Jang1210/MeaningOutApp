//
//  AddProductViewModel.swift
//  MeaningOutApp
//
//  Created by 장예지 on 7/13/24.
//

import Foundation
import RealmSwift

final class AddProductViewModel {
    let repository = CartRepository()
    
    var inputSelectIndex: Observable<Int?> = Observable(nil)
    lazy var outputCategoryList: Observable<Results<Category>> = Observable(repository.fetchCategory())
    var outputSelectedCategory: Observable<Category?> = Observable(nil)
    
    init(){
        bind()
    }
    
    private func bind(){
        inputSelectIndex.bind { index in
            guard let index else { return }
            
            self.outputSelectedCategory.value = self.outputCategoryList.value[index]
        }
    }
}
