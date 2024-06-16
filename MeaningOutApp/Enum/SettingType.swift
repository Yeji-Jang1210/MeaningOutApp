//
//  SettingType.swift
//  MeaningOutApp
//
//  Created by 장예지 on 6/16/24.
//

import Foundation

enum SettingType: Int, CaseIterable {
    case cartList
    case faq
    case contactUs
    case notificationSettings
    case deleteAccount
    
    var title: String {
        switch self {
        case .cartList:
            return "나의 장바구니 목록"
        case .faq:
            return "자주 묻는 질문"
        case .contactUs:
            return "1:1 문의"
        case .notificationSettings:
            return "알림 설정"
        case .deleteAccount:
            return "탈퇴하기"
        }
    }
}

