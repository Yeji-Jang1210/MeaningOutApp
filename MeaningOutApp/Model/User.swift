//
//  User.swift
//  MeaningOutApp
//
//  Created by 장예지 on 6/16/24.
//

import UIKit
import SwiftyUserDefaults

struct User {
    private init(){}
    
    static var nickname: String {
        get {
            return Defaults.nickname
        }
        
        set {
            Defaults.nickname = newValue
        }
    }
    
    static var signupDate: Date? {
        get {
            return Defaults.signupDate
        }
        
        set {
            Defaults.signupDate = newValue
        }
    }
    
    static var profileImageId: Int? {
        get {
            return Defaults.profileImageId
        }
        
        set {
            Defaults.profileImageId = newValue
        }
    }
    
    static var cartList: [String] {
        get {
            return Defaults.cartList
        }
        
        set {
            Defaults.cartList = newValue
        }
    }
    
    static var signupDateText: String {
        guard let date = signupDate else { return "" }
        let format = DateFormatter()
        format.dateFormat = "yyyy. MM. dd"
        return "\(format.string(from: date)) 가입"
    }
    
    static var cartListText: NSMutableAttributedString {
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
    
    static func delete(){
        nickname = ""
        profileImageId = nil
        signupDate = nil
        cartList = []
        Defaults.currentSearchList = []
        
    }
}
