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
    
    static func request(_ request: String,
                        method: HTTPMethod = .get,
                        parameters: Parameters? = nil,
                        completion: @escaping (Any?, Bool) -> Void) {
        
        let requestString = api + request
        AF.request(requestString.cleared, method: method, parameters: parameters, headers: authHeader)
            .responseJSON { (response) in
                completion(response.value, response.error != nil)
        }
    }
}
