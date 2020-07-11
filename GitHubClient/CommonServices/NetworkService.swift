//
//  NetworkService.swift
//  GitHubClient
//
//  Created by Darya on 21.06.2020.
//  Copyright © 2020 ililonne. All rights reserved.
//

import Alamofire

class NetworkService {
    
    private static let api = "​https://api.github.com/"
    
    private static var authHeader: HTTPHeaders? {
        guard let token = StorageService.getKeychainParameter(key: .token) else {
              return nil
          }
          let header: HTTPHeaders = [
              "Authorization": "token \(token)"
          ]
          return header
      }
    
    static func requestDecodable<T: Decodable>(_ request: String,
                                               method: HTTPMethod,
                                               parameters: Parameters? = nil,
                                               completion: @escaping (T?, Bool) -> Void) {
        
        let requestString = api + request
        AF.request(requestString.cleared, method: .get, parameters: parameters, headers: authHeader)
            .validate()
            .responseDecodable(completionHandler: { (response: DataResponse<T, AFError>) in
                completion(response.value, response.error != nil)
        })
    }
    
    static func request(_ request: String,
                        method: HTTPMethod,
                        parameters: Parameters? = nil,
                        completion: @escaping ([String: Any]?, Bool) -> Void) {
        
        let requestString = api + request
        AF.request(requestString.cleared, method: .get, parameters: parameters, headers: authHeader)
            .responseJSON { (response) in
                completion(response.value as? [String : Any], response.error != nil)
        }
    }
}
