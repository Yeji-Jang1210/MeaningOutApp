//
//  CharacterStyle.swift
//  MeaningOutApp
//
//  Created by 장예지 on 6/18/24.
//

import UIKit

enum CharacterStyle {
    case select
    case unselect
    case setting
    
    var borderWidth: CGFloat {
        switch self {
        case .unselect:
            return 1
        default:
            return 3
        }
    }
    
    var borderColor: CGColor {
        switch self {
        case .unselect:
            return Color.lightGray.cgColor
        default:
            return Color.primaryOrange.cgColor
        }
    }
    
    var alpha: CGFloat {
        switch self {
        case .unselect:
            return 0.5
        default:
            return 1
        }
    }
}
