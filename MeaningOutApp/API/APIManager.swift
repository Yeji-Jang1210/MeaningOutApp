//
//  APIManager.swift
//  MeaningOutApp
//
//  Created by 장예지 on 6/26/24.
//

import Foundation
import Alamofire

enum APIManager {
    
    case search(query: String, sort: FilterType, start: Int)
    
    var baseURL: String {
        return "https://openapi.naver.com/v1/"
    }
    
    var url: String {
        switch self {
        case .search:
            return baseURL+"search/shop.json"
        }
    }
    
    var headers: HTTPHeaders {
        return [
            "X-Naver-Client-Id": APIInfo.clientId,
            "X-Naver-Client-Secret": APIInfo.clientSecret
        ]
    }
    
    var parameters: Parameters {
        switch self {
        case .search(let query, let sort, let start):
            return [
                "query": query,
                "sort": sort.queryString,
                "start": start,
                "display": 30,
            ]
        }
    }
}
