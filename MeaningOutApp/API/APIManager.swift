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
        return "https://openapi.naver.com"
    }
    
    var path: String {
        switch self {
        case .search:
            return "/v1/search/shop.json"
        }
    }
    
    var headers: HTTPHeaders {
        return [
            "X-Naver-Client-Id": APIInfo.clientId,
            "X-Naver-Client-Secret": APIInfo.clientSecret
        ]
    }
    
    var method: HTTPMethod {
        switch self {
        case .search:
            return .get
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .search(let query, let sort, let start):
            return [
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "sort", value: sort.queryString),
                URLQueryItem(name: "start", value: String(start)),
                URLQueryItem(name: "display", value: "30")
            ]
        }
    }
}
