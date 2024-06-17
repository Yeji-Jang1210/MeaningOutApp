//
//  ImageAssets.swift
//  MeaningOutApp
//
//  Created by 장예지 on 6/13/24.
//

import UIKit

enum ImageAssets: String {
//MARK: systemNamed
    case search = "magnifyingglass"
    case person = "person"
    case leftArrow = "chevron.left"
    case rightArrow = "chevron.right"
    case clock = "clock"
    case xmark = "xmark"
    case camera = "camera.fill"

//MARK: - Assets
    case empty = "empty"
    case launch = "launch"
    case like_selected = "like_selected"
    case like_unselected = "like_unselected"
    
    var image: UIImage? {
        switch self {
        case .empty, .launch, .like_selected, .like_unselected:
            return UIImage(named: self.rawValue)
        default:
            return UIImage(systemName: self.rawValue)
        }
    }
    

}
