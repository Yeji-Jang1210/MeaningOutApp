//
//  APIService.swift
//  MeaningOutApp
//
//  Created by 장예지 on 6/14/24.
//

import UIKit
import Alamofire
import Toast

enum NetworkingError: Error {
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
    
    var message: String {
        switch self {
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
        }
    }
}

class APIService {
    
    static var shared = APIService()
    
    private init(){}
    
    func networking<T: Codable>(api: APIManager, of: T.Type, completion: @escaping (NetworkResult<T>) -> ()){
        //        guard let url = URL(string: api.url) else { return }
        //        AF.request(url,
        //                   method: .get,
        //                   parameters: api.parameters,
        //                   encoding: URLEncoding.queryString,
        //                   headers: api.headers).responseDecodable(of: T.self){ response in
        //            switch response.result {
        //            case .success(let data):
        //                completion(.success(data))
        //            case .failure(let error):
        //                completion(.error(error))
        //            }
        //        }
        
        var component = URLComponents(string: api.baseURL)
        component?.path = api.path
        component?.queryItems = api.queryItems
        
        print(component?.url)
        
        if let url = component?.url {
            
            do {
                let request = try URLRequest(url: url, method: api.method, headers: api.headers)
                
                URLSession.shared.dataTask(with: request) { data, response, error in
                    guard error == nil else {
                        completion(.error(.badRequest))
                        return
                    }
                    
                    guard let response = response as? HTTPURLResponse else {
                        completion(.error(.invalidResponse))
                        return
                    }
                    
                    switch response.statusCode {
                    case 200..<300:
                        guard let data = data else {
                            completion(.error(.invalidData))
                            return
                        }
                        do {
                            let result = try JSONDecoder().decode(T.self, from: data)
                            completion(.success(result))
                        } catch {
                            completion(.error(.jsonDecodedError))
                        }
                        
                    case 300..<400:
                        completion(.error(.redirection))
                    case 400:
                        completion(.error(.badRequest))
                    case 403:
                        completion(.error(.forbidden))
                    case 404:
                        completion(.error(.notFound))
                    case 405..<500:
                        completion(.error(.clientError))
                    case 500..<600:
                        completion(.error(.serverError))
                    default:
                        completion(.error(.unownedError))
                    }
                    
                }.resume()
            } catch {
                
            }
            
        } else {
            completion(.error(.invalidURL))
        }
    }
}

enum NetworkResult<T> {
    case success(T)
    case error(NetworkingError)
}
