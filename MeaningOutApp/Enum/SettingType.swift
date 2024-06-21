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
            return Localized.cartList.title
        case .faq:
            return Localized.faq.title
        case .contactUs:
            return Localized.contactUs.title
        case .notificationSettings:
            return Localized.notification_settings.title
        case .deleteAccount:
            return Localized.deleteAccount.title
        }
    }
}

