//
//  APIParameters.swift
//  MeaningOutApp
//
//  Created by 장예지 on 6/14/24.
//

import UIKit
import Alamofire

struct APIParameters {
    let query: String
    let sort: FilterType
    
    //default: 1, max: 1000
    let start: Int
    
    var encodedParameters: [String: Any] {
        return [
            "query": query,
            "sort": sort.queryString,
            "start": start,
            "display": 30,
        ]
    }
}

