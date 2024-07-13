//
//  ProductWebViewModel.swift
//  MeaningOutApp
//
//  Created by 장예지 on 7/10/24.
//

import Foundation
import WebKit

class ProductWebViewModel {
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
        bindAction()
    }
    
    private func bindAction(){
        inputFindProductTrigger.bind { _ in
            if let id = self.product?.productId {
                self.outputIsSelected.value = self.repository.findProductId(productId: id)
            }
        }
        
        inputIsSelected.bind { result in
            guard let product = self.product, let result = result else { return }
            
            if result {
                self.outputPresentCategoryVC.value = ()
            } else {
                self.deleteProductInCategory(id: product.productId, isSelected: result)
            }
        }
        
        inputAddProductTrigger.bind { category in
            guard let category = category, let product = self.product else { return }
            self.repository.createProductInCategory(category: category, product: product)
            self.outputIsSelected.value = true
            self.outputPresentToast.value = true
        }
        
        inputLoadWebLinkTrigger.bind { _ in
            print(self.url)
            self.outputWebLink.value = URL(string: self.url)
        }
    }
    
    private func deleteProductInCategory(id: String, isSelected: Bool){
        self.repository.deleteItemForId(productId: id)
        self.outputIsSelected.value = isSelected
        self.outputPresentToast.value = isSelected
    }
}
