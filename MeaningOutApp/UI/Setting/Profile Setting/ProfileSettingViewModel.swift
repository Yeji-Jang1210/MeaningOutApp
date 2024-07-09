//
//  ProfileSettingViewModel.swift
//  MeaningOutApp
//
//  Created by 장예지 on 7/9/24.
//

import Foundation

enum ValidateNicknameError: Error {
    case invalid_nickname
    case invalid_range
    case contains_specific_character
    case contains_number
    
    var message: String {
        switch self {
        case .invalid_nickname:
            return ""
        case .invalid_range:
            return Localized.nickname_range_error.text
        case .contains_specific_character:
            return Localized.nickname_contains_specific_character.text
        case .contains_number:
            return Localized.nickname_contains_number.text
        }
    }
}

class ProfileSettingViewModel {
//MARK: - Input
    var inputNickname = Observable<String?>(User.shared.nickname)
    var inputImageNum = Observable<Int?>(User.shared.profileImageId)
    var inputIsSaved: Observable<Bool> = Observable(false)
    
//MARK: - Output
    var outputNickname = Observable<String?>(nil)
    var outputNicknameStatus = Observable<ValidateNicknameError?>(nil)
    var outputIsNicknameValid = Observable<Bool>(false)
    var outputImageNum = Observable(0)
    var outputIsSaved = Observable<Bool?>(nil)
    
    init(){
        inputNickname.bind { nickname in
            self.outputNickname.value = nickname
            self.validateNickname { status, isValid in
                self.outputNicknameStatus.value = status
                self.outputIsNicknameValid.value = isValid
            }
        }
        
        inputImageNum.bind { num in
            self.outputImageNum.value = num ?? Int.random(in: 0...Character.maxCount)
        }
        
        inputIsSaved.bind { isSave in
            if isSave {
                self.saveData()
            }
        }
    }
    
    func validateNickname(completion: @escaping ( ValidateNicknameError?, Bool) -> ()){
        guard let nickname = inputNickname.value else {
            completion(ValidateNicknameError.invalid_nickname, false)
            return
        }
        
        let specificCharacter = CharacterSet(charactersIn: "@#$%")
        let numbers = CharacterSet.decimalDigits
        
        if nickname.count < 2 || nickname.count >= 10 {
            completion(ValidateNicknameError.invalid_range, false)
            return
        }
        
        if nickname.rangeOfCharacter(from: specificCharacter) != nil {
            completion(ValidateNicknameError.contains_specific_character, false)
            return
        }

        if nickname.rangeOfCharacter(from: numbers) != nil {
            completion(ValidateNicknameError.contains_number, false)
            return
        }
        
        completion(nil, true)
        return
    }
    
    func saveData(){
        guard let nickname = outputNickname.value else {
            outputIsSaved.value = false
            return
        }
        
        User.shared.nickname = nickname
        User.shared.profileImageId = outputImageNum.value
        User.shared.signupDate = Date.now
        
        outputIsSaved.value = true
        
    }
}
