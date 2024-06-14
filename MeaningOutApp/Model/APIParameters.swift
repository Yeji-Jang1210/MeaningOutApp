//
//  APIParameters.swift
//  MeaningOutApp
//
//  Created by 장예지 on 6/14/24.
//

import UIKit
import Alamofire

enum SortType: String {
    case similarity = "sim"
    case date = "date"
    case lowPrice = "asc"
    case highPrice = "dsc"
}

struct APIParameters {
    let query: String
    let sort: SortType = .similarity
    
    //default: 1, max: 100
    let start:Int = 1
    
    var encodedParameters: [String: Any] {
        return [
            "query": query,
            "sort": sort.rawValue,
            "start": start,
            "display": 30,
        ]
    }
}

