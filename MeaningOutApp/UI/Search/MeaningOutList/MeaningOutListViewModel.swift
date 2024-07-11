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
    let repository = CartRepository()
    
    var inputFilter: Observable<FilterType> = Observable(.similarity)
    var inputProductSelected: Observable<(Int?, Bool?)> = Observable((nil, nil))
    var inputNextPageTrigger: Observable<Void?> = Observable(nil)
    var inputCallAnimation: Observable<LottieAnimationType> = Observable(.none)
    
    var outputProducts: Observable<[Product]> = Observable([])
    var outputTotal = Observable(0)
    var outputCallAPIError: Observable<NetworkingError?> = Observable(nil)
    var outputCallAnimation: Observable<LottieAnimationType?> = Observable(nil)
    var outputCallSelectedProductToast: Observable<Bool?> = Observable(nil)
    lazy var outputFilter: Observable<FilterType> = Observable(inputFilter.value)
    
    var text: String = ""
    var selectIndex: Int?
    var selectedProduct: Product?
    
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
        
        inputProductSelected.bind { index, isSelected in
            guard let index else { return }
            self.selectedProduct = self.outputProducts.value[index]
            
            guard let isSelected, let product = self.selectedProduct else { return }
            
            if isSelected {
                self.repository.addItem(item: CartItem(product))
                self.outputCallAnimation.value = .adding
            } else {
                self.repository.deleteItemForId(productId: product.productId)
            }
            
            self.outputCallSelectedProductToast.value = isSelected
            
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
