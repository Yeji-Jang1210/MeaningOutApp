//
//  User.swift
//  MeaningOutApp
//
//  Created by 장예지 on 6/16/24.
//

import UIKit
import SwiftyUserDefaults

class User {
    static var shared = User()
    
    private init(){}
    
    var nickname: String {
        get {
            return Defaults.nickname
        }
        
        set {
            Defaults.nickname = newValue
        }
    }
    
    var signupDate: Date? {
        get {
            return Defaults.signupDate
        }
        
        set {
            Defaults.signupDate = newValue
        }
    }
    
    var profileImageId: Int? {
        get {
            return Defaults.profileImageId
        }
        
        set {
            Defaults.profileImageId = newValue
        }
    }
    
    var signupDateText: String {
        guard let date = signupDate else { return "" }
        let format = DateFormatter()
        format.dateFormat = "yyyy. MM. dd"
        return "\(format.string(from: date)) 가입"
    }
    
    func delete(){
        nickname = ""
        profileImageId = nil
        signupDate = nil
        Defaults.currentSearchList = []
    }
}
