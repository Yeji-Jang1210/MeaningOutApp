//
//  ProductWebViewModel.swift
//  MeaningOutApp
//
//  Created by 장예지 on 7/10/24.
//

import Foundation
import WebKit

final class ProductWebViewModel {
    var repository = CartRepository()
    lazy var categories = repository.fetchCategory()
    
    var url: String = ""
    var product: Product?
    
    var inputLoadWebLinkTrigger: Observable<Void?> = Observable(nil)
    var inputFindProductTrigger: Observable<Void?> = Observable(nil)
    var inputIsSelected: Observable<Bool?> = Observable(nil)
    var inputAddProductTrigger: Observable<Category?> = Observable(nil)
    
    var outputIsSelected: Observable<Bool?> = Observable(nil)
    var outputPresentCategoryVC: Observable<Void?> = Observable(nil)
    var outputPresentToast: Observable<Bool?> = Observable(nil)
    var outputWebLink: Observable<URL?> = Observable(nil)
    var outputIsLoading: Observable<Bool?> = Observable(nil)
    
    init(url: String, product: Product){
        self.url = url
        self.product = product
        bind()
    }
    
    private func bind(){
        inputFindProductTrigger.bind { [weak self] trigger in
            guard let self, trigger != nil else { return }
            if let id = product?.productId {
                outputIsSelected.value = repository.findProductId(productId: id)
            }
        }
        
        inputIsSelected.bind { [weak self] result in
            guard let self, let result, let product else { return }
            
            if result {
                outputPresentCategoryVC.value = ()
            } else {
                deleteProductInCategory(id: product.productId, isSelected: result)
            }
        }
        
        inputAddProductTrigger.bind { [weak self] category in
            guard let self, let category, let product else { return }
            repository.createProductInCategory(category: category, product: product)
            outputIsSelected.value = true
            outputPresentToast.value = true
        }
        
        inputLoadWebLinkTrigger.bind { [weak self] trigger in
            guard let self, trigger != nil else { return }
            outputWebLink.value = URL(string: self.url)
        }
    }
    
    private func deleteProductInCategory(id: String, isSelected: Bool){
        self.repository.deleteItemForId(productId: id)
        self.outputIsSelected.value = isSelected
        self.outputPresentToast.value = isSelected
    }
}
