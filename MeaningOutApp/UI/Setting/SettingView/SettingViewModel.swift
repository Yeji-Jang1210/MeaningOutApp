//
//  SettingViewModel.swift
//  MeaningOutApp
//
//  Created by 장예지 on 7/11/24.
//

import Foundation

final class SettingViewModel {
    let repository = CartRepository()
    
    var inputRefreshCartListCountTrigger = Observable<Void?>(nil)
    var inputDeleteAccountTrigger = Observable<Void?>(nil)
    var inputSelectSettingType = Observable<Int?>(nil)
    
    var outputCartListText = Observable<(String, String)>(("", ""))
    var outputSelectSettingType = Observable<SettingType?>(nil)
    var outputIsDeleteSucceeded = Observable<Bool?>(nil)
    
    init(){
        bind()
    }
    
    func bind(){
        inputRefreshCartListCountTrigger.bind { [weak self] trigger in
            guard let self else { return }
            let count = repository.fetch().count
            let boldString = "\(count)개"
            outputCartListText.value = (boldString, boldString + "의 상품")
        }
        
        inputSelectSettingType.bind { [weak self] rawValue in
            guard let self, let rawValue, let type = SettingType(rawValue: rawValue) else { return }
            outputSelectSettingType.value = type
        }
        
        inputDeleteAccountTrigger.bind { [weak self] trigger in
            guard let self, trigger != nil else { return }
            
            User.shared.delete()
            repository.deleteAll { [weak self] result in
                guard let self else { return }
                outputIsDeleteSucceeded.value = result
            }
        }
    }
}
