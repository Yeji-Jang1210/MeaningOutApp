//
//  Localized.swift
//  MeaningOutApp
//
//  Created by 장예지 on 6/13/24.
//

import Foundation

enum Localized {
    
    //tabbar
    case tabbar_search
    case tabbar_setting
    case tabbar_cart
    
    case title
    case profile_setting
    case profile_edit
    case profile_edit_save_button
    case start
    case complete
    case nickname_placeholder
    case searchBar_placeholder
    case current_search
    case delete_all
    case empty
    case profile_tab_title
    case result_count_text(count: Int)
    case deleteAccount_dlg
    case search_tab_nav
    case like_select_message
    case like_unselect_message
    case search_cartItem_placeholder
    
    //settingType
    case cartList
    case usersCartList
    case faq
    case contactUs
    case notification_settings
    case deleteAccount
    
    //validate nickname
    case nickname_range_error
    case nickname_contains_specific_character
    case nickname_contains_number
    
    //NetworkingError
    case invalidURL
    case invalidData
    case invalidResponse
    case redirection
    case badRequest
    case forbidden
    case notFound
    case clientError
    case serverError
    case jsonDecodedError
    case unownedError
    
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
        case .current_search:
            return "최근검색"
        case .delete_all:
            return "전체삭제"
        case .searchBar_placeholder:
            return "브랜드, 상품 등을 입력하세요"
        case .empty:
            return "최근 검색어가 없어요"
        case .result_count_text(let count):
            return "\(count.formatted())개의 검색결과"
        case .nickname_range_error:
            return "2글자 이상 10글자 미만으로 입력해주세요"
        case .nickname_contains_specific_character:
            return "닉네임에 @, #, $, % 는 포함할 수 없어요"
        case .nickname_contains_number:
            return "닉네임에 숫자는 포함할 수 없어요"
        case .search_cartItem_placeholder:
            return "상품의 이름을 입력해주세요."
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
        case .profile_edit_save_button:
            return "저장"
        case .profile_tab_title:
            return "SETTING"
        case .tabbar_search:
            return "검색"
        case .tabbar_setting:
            return "설정"
        case .tabbar_cart:
            return "장바구니"
        case .search_tab_nav:
            return "\(User.shared.nickname)'s MEANING OUT"
        case .deleteAccount_dlg, .deleteAccount:
            return "탈퇴하기"
        case .cartList:
            return "나의 장바구니 목록"
        case .usersCartList:
            return "\(User.shared.nickname)의 장바구니 목록"
        case .faq:
            return "자주 묻는 질문"
        case .contactUs:
            return "1:1 문의"
        case .notification_settings:
            return  "알림 설정"
        default:
            return ""
        }
    }
    
    var message: String {
        switch self {
        case .deleteAccount_dlg:
            return "탈퇴를 하면 데이터가 모두 초기화됩니다.\n탈퇴 하시겠습니까?"
        case .like_select_message:
            return "장바구니에 추가했습니다."
        case .like_unselect_message:
            return "장바구니에서 삭제했습니다."
        case .invalidURL:
            return "유효하지 않은 URL입니다."
        case .invalidData:
            return "데이터를 가져오는데 오류가 생겼습니다."
        case .invalidResponse:
            return "잘못된 응답입니다."
        case .redirection:
            return "리다이렉션 오류입니다."
        case .badRequest:
            return "잘못된 요청입니다."
        case .forbidden:
            return "접근이 금지되었습니다."
        case .notFound:
            return "요청한 리소스를 찾을 수 없습니다."
        case .clientError:
            return "클라이언트 오류입니다."
        case .serverError:
            return "서버 오류입니다."
        case .jsonDecodedError:
            return "JSON 디코딩 오류입니다."
        case .unownedError:
            return "알 수 없는 오류입니다."
        default:
            return ""
        }
    }
    
    var confirm: String {
        switch self {
        case .deleteAccount_dlg:
            return "확인"
        default:
            return ""
        }
    }
    
    var cancel: String {
        switch self {
        case .deleteAccount_dlg:
            return "취소"
        default:
            return ""
        }
    }
}
