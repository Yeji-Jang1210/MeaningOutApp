//
//  FilterType.swift
//  MeaningOutApp
//
//  Created by 장예지 on 6/16/24.
//

import Foundation

enum FilterType: Int, CaseIterable {
    case similarity
    case date
    case highPrice
    case lowPrice
    
    var queryString: String {
        switch self {
        case .similarity:
            return "sim"
        case .date:
            return "date"
        case .highPrice:
            return "dsc"
        case .lowPrice:
            return "asc"
        }
    }
    
    var title: String {
        switch self {
        case .similarity:
            return "정확도"
        case .date:
            return "날짜순"
        case .highPrice:
            return "가격높은순"
        case .lowPrice:
            return "가격낮은순"
        }
    }
}
