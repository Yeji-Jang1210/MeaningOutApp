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
        inputRefreshCartListCountTrigger.bind { trigger in
            let count = self.repository.fetch().count
            let boldString = "\(count)개"
            self.outputCartListText.value = (boldString, boldString + "의 상품")
        }
        
        inputSelectSettingType.bind { rawValue in
            guard let rawValue, let type = SettingType(rawValue: rawValue) else { return }
            self.outputSelectSettingType.value = type
        }
        
        inputDeleteAccountTrigger.bind { trigger in
            guard trigger != nil else { return }
            
            User.shared.delete()
            self.repository.deleteAll { result in
                self.outputIsDeleteSucceeded.value = result
            }
        }
    }
}
