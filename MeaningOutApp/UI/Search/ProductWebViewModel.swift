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
    
    var outputIsSelected: Observable<Bool?> = Observable(nil)
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
                self.repository.addItem(item: CartItem(product))
            } else {
                self.repository.deleteItemForId(productId: product.productId)
            }
            
            self.outputIsSelected.value = result
            self.outputPresentToast.value = result
        }
        
        inputLoadWebLinkTrigger.bind { _ in
            print(self.url)
            self.outputWebLink.value = URL(string: self.url)
        }
    }
}
