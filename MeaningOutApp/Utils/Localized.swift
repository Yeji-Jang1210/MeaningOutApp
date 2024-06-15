//
//  Localized.swift
//  MeaningOutApp
//
//  Created by 장예지 on 6/13/24.
//

import Foundation

enum Localized {
    case title
    case profile_setting
    case profile_edit
    case start
    case complete
    case nickname_placeholder
    case searchBar_placeholder
    case empty
    case profile_tab_title
    case tabbar_search
    case tabbar_setting
    case result_count_text(count: Int)
    
    var text: String {
        switch self {
        case .title:
            return "MeaningOut"
        case .start:
            return "시작하기"
        case .complete:
            return "완료"
        case .nickname_placeholder:
            return "닉네임을 입력해 주세요:)"
        case .searchBar_placeholder:
            return "브랜드, 상품 등을 입력하세요"
        case .empty:
            return "최근 검색어가 없어요"
        case .result_count_text(let count):
            return "\(count.formatted())개의 검색결과"
        default:
            return ""
        }
    }
    
    var title: String {
        switch self {
        case .profile_setting:
            return "PROFILE SETTING"
        case .profile_edit:
            return "EDIT PROFILE"
        case .profile_tab_title:
            return "SETTING"
        case .tabbar_search:
            return "검색"
        case .tabbar_setting:
            return "설정"
        default:
            return ""
        }
    }
}
