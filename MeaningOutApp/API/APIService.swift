//
//  APIService.swift
//  MeaningOutApp
//
//  Created by 장예지 on 6/14/24.
//

import UIKit
import Alamofire
import Toast

class APIService {
    
    static var shared = APIService()
    
    private init(){}
    
    func networking<T: Codable>(api: APIManager, of: T.Type, completion: @escaping (NetworkResult<T>) -> ()){
        guard let url = URL(string: api.url) else { return }
        AF.request(url,
                   method: .get,
                   parameters: api.parameters,
                   encoding: URLEncoding.queryString,
                   headers: api.headers).responseDecodable(of: T.self){ response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.error(error))
            }
        }
    }
}

enum NetworkResult<T> {
    case success(T)
    case error(AFError)
}
