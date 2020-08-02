//
//  LoginViewController.swift
//  GitHubClient
//
//  Created by Darya on 11.07.2020.
//  Copyright © 2020 ililonne. All rights reserved.
//
import Alamofire

class LoginService {
  
    private static let authorizationString = "https://github.com/login/oauth/authorize"
    private static let accessTokenString = "https://github.com/login/oauth/access_token"
    private static let clientID = "0ab53cbf86f9f5a5c750"
    private static let clientSecret = "52b5eeba199f2916a77ebafccec809c4980a6bcc"
  
    static func getRequestAuthorizationURL() -> URL? {
    
        let clientIDQuery = URLQueryItem(name: "client_id", value: clientID)
        let scopeQuery: URLQueryItem  = URLQueryItem(name: "scope", value: "user gist ")
    
        if let authorizationURL = URL(string: authorizationString) {
            var components = URLComponents(url: authorizationURL, resolvingAgainstBaseURL: true)
            components?.queryItems = [clientIDQuery, scopeQuery]
    
            return components?.url
        }
        return nil
    }

    static func canRequestToken(url: URL) -> Bool {
        findCodeInURL(url: url) != nil
    }

    static func findCodeInURL(url: URL) -> String? {
        if let components = URLComponents(url: url, resolvingAgainstBaseURL: true) {
            for queryItem in components.queryItems ?? [] {
                if queryItem.name == "code" {
                    return queryItem.value
                }
            }
        }
        return nil
    }

    static func requestAuthToken(url: URL) {
        let accessCode = findCodeInURL(url: url)!

        let params: Parameters = ["client_id": clientID,
                                  "client_secret": clientSecret,
                                  "code": accessCode]
    
        let headers: HTTPHeaders = ["Accept": "application/json"]
    
    
        guard let accessTokenURL = URL(string: accessTokenString) else {
            return
        }
        
        AF.request(accessTokenURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { (response) in
                if let responseJSON = response.value as? [String:Any],
                   let token = responseJSON["access_token"] as? String {
                    StorageService.setKeychainParameter(token, key: .token)
                    StorageService.userIsLogged = true
                    NotificationCenter.default.post(name: .loginSuccesfull, object: nil, userInfo: nil)
                }
            }
    
    }
}
