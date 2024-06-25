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
    
    var cartList: [String] {
        get {
            return Defaults.cartList
        }
        
        set {
            Defaults.cartList = newValue
        }
    }
    
    var signupDateText: String {
        guard let date = signupDate else { return "" }
        let format = DateFormatter()
        format.dateFormat = "yyyy. MM. dd"
        return "\(format.string(from: date)) 가입"
    }
    
    var cartListText: NSMutableAttributedString {
        let boldString = "\(cartList.count)개"
        let fullString = boldString + "의 상품"
        
        let attributedString = NSMutableAttributedString(string: fullString)
        let boldFontAttribute: [NSAttributedString.Key: Any] = [.font: BaseFont.medium.boldFont]
        
        if let boldRange = fullString.range(of: boldString){
            let nsRange = NSRange(boldRange, in: fullString)
            
            attributedString.addAttributes(boldFontAttribute, range: nsRange)
        }
        
        return attributedString
    }
    
    func delete(){
        nickname = ""
        profileImageId = nil
        signupDate = nil
        cartList = []
        Defaults.currentSearchList = []
        
    }
}
