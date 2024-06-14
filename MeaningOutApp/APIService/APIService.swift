//
//  APIService.swift
//  MeaningOutApp
//
//  Created by 장예지 on 6/14/24.
//

import UIKit
import Alamofire

struct APIService {
    
    static let headers: HTTPHeaders = [
        "X-Naver-Client-Id": APIInfo.clientId,
        "X-Naver-Client-Secret": APIInfo.clientSecret
    ]
    
    static func networking(params: APIParameters, completion: @escaping (NetworkResult) -> ()){
        guard let url = URL(string: APIInfo.baseUrl) else { return }
        AF.request(url, method: .get, parameters: params.encodedParameters, encoding: URLEncoding.queryString, headers: headers).responseDecodable(of: ShoppingItemList.self){ response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.error(error))
            }
        }
    }
}

enum NetworkResult {
    case success(ShoppingItemList)
    case error(Error)
}
