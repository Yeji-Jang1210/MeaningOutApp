//
//  SelectCharacterViewModel.swift
//  MeaningOutApp
//
//  Created by 장예지 on 7/10/24.
//

import Foundation

class SelectCharacterViewModel {
    var inputCharacterNum = Observable(0)
    var outputCharacterNum = Observable(0)
    
    init(){
        inputCharacterNum.bind { num in
            self.outputCharacterNum.value = num
        }
        
    }
}
