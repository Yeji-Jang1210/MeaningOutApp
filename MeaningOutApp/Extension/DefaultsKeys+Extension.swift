//
//  DefaultsKeys+Extension.swift
//  MeaningOutApp
//
//  Created by 장예지 on 6/13/24.
//

import UIKit
import SwiftyUserDefaults

extension DefaultsKeys {
    //User
    var nickname: DefaultsKey<String>{.init("nickname", defaultValue: "")}
    var signupDate: DefaultsKey<Date?>{.init("signupDate", defaultValue: nil)}
    var profileImageId: DefaultsKey<Int?>{.init("profileImageId", defaultValue: nil)}
    
    //Search Item name
    var currentSearchList: DefaultsKey<[String]>{ .init("currentSearchList", defaultValue: []) }
    var cartList: DefaultsKey<[String]>{ .init("cartList", defaultValue: []) }
}
