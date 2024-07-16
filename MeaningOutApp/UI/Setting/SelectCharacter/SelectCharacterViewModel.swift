//
//  SelectCharacterViewModel.swift
//  MeaningOutApp
//
//  Created by 장예지 on 7/10/24.
//

import Foundation

final class SelectCharacterViewModel {
    var inputCharacterNum = Observable(0)
    var outputCharacterNum = Observable(0)
    
    init(){
        inputCharacterNum.bind { [weak self] num in
            DispatchQueue.main.async {
                self?.outputCharacterNum.value = num
            }
        }
    }
}
