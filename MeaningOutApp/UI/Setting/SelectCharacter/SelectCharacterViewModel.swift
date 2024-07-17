//
//  SelectCharacterViewModel.swift
//  MeaningOutApp
//
//  Created by 장예지 on 7/10/24.
//

import Foundation

final class SelectCharacterViewModel: BaseVM {
    var inputCharacterNum = Observable(0)
    var outputCharacterNum = Observable(0)
    
    override func bind() {
        inputCharacterNum.bind { [weak self] num in
            DispatchQueue.main.async {
                self?.outputCharacterNum.value = num
            }
        }
    }
}
