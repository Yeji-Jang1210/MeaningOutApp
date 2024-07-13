//
//  MeaningOutListViewModel.swift
//  MeaningOutApp
//
//  Created by 장예지 on 7/10/24.
//

import Foundation

enum LottieAnimationType {
    case none
    case adding
    case loading
}

final class MeaningOutListViewModel {
    var inputFilter: Observable<FilterType> = Observable(.similarity)
    var inputNextPageTrigger: Observable<Void?> = Observable(nil)
    var inputCallAnimation: Observable<LottieAnimationType> = Observable(.none)
    var inputIsLikeButtonSelected: Observable<(Bool?, Int?)> = Observable((nil, nil))
    var inputAddProductTrigger: Observable<Category?> = Observable(nil)
    
    var outputProducts: Observable<[Product]> = Observable([])
    var outputTotal = Observable(0)
    var outputCallAPIError: Observable<NetworkingError?> = Observable(nil)
    var outputCallAnimation: Observable<LottieAnimationType?> = Observable(nil)
    var outputPresentCategoryVC: Observable<Void?> = Observable(nil)
    var outputCallSelectedProductToast: Observable<Bool?> = Observable(nil)
    lazy var outputFilter: Observable<FilterType> = Observable(inputFilter.value)
    
    let repository = CartRepository()
    var text: String = ""
    var selectProductIndex: Int?
    var start:Int = 1
    var isEnd: Bool {
        return start > outputTotal.value  - 30 || start > 1000
    }
    
    
    init(text: String){
        self.text = text
        inputFilter.bind { type in
            self.start = 1
            self.callAPI()
            self.outputFilter.value = type
        }
        
        inputIsLikeButtonSelected.bind { isSelected, index in
            guard let isSelected = isSelected, let index = index else { return }
            
            self.selectProductIndex = index
            
            if isSelected {
                //present addCategory VC
                self.outputPresentCategoryVC.value = ()
            } else {
                //delete
                self.repository.deleteItemForId(productId: self.outputProducts.value[index].productId)
                self.outputCallSelectedProductToast.value = false
            }
        }
        
        inputAddProductTrigger.bind { category in
            //index is category index
            guard let category = category, let selectProductIndex = self.selectProductIndex  else { return }
            
            self.repository.createProductInCategory(category: category, product: self.outputProducts.value[selectProductIndex])
                
            self.outputCallSelectedProductToast.value = true
            self.outputCallAnimation.value = .adding
        }
        
        inputNextPageTrigger.bind { _ in
            self.start += 30
            self.callAPI()
        }
        
        inputCallAnimation.bind { type in
            self.outputCallAnimation.value = type
        }

    }
    
    private func callAPI(){
        self.outputCallAnimation.value = .loading
        APIService.shared.networking(api: .search(query: text, sort: inputFilter.value, start: start), of: ShoppingItemList.self) { networkResult in
            switch networkResult {
            case .success(let data):
                if self.start == 1 {
                    self.outputProducts.value = data.items
                } else {
                    self.outputProducts.value.append(contentsOf: data.items)
                }
                
                self.outputTotal.value = data.total
                self.outputCallAnimation.value = LottieAnimationType.none
            case .error(let error):
                self.outputCallAPIError.value = error
            }
        }
    }
    
    public func productIsAddedCart(_ product: Product) -> Bool{
        return repository.findProductId(productId: product.productId)
    }
}
