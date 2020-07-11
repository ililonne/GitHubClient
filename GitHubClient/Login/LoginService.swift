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
    private static let redirectString = "GitHubClient://Main.LoginViewController"
    private static let accessTokenString = "https://github.com/login/oauth/access_token"
    private static let clientID = "0ab53cbf86f9f5a5c750"
    private static let clientSecret = "52b5eeba199f2916a77ebafccec809c4980a6bcc"
  
    static func requestAuthorization() {
    
        let clientIDQuery = URLQueryItem(name: "client_id", value: clientID)
        let redirectURLQuery = URLQueryItem(name: "redirect_uri", value: redirectString)
        let scopeQuery: URLQueryItem  = URLQueryItem(name: "scope", value: "user gist ")
    
        if let authorizationURL = URL(string: authorizationString) {
            var components = URLComponents(url: authorizationURL, resolvingAgainstBaseURL: true)
            components?.queryItems = [clientIDQuery, redirectURLQuery, scopeQuery]
    
            if let url = components?.url {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }

    static func requestAuthToken(url: URL) {
        var accessCode: String = ""
        if let components = URLComponents(url: url, resolvingAgainstBaseURL: true) {
            for queryItem in components.queryItems ?? [] {
                if queryItem.name == "code" {
                    accessCode = queryItem.value!
                }
            }
        }

        let params: Parameters = ["client_id": clientID,
                                  "client_secret": clientSecret,
                                  "code": accessCode,
                                  "redirect_uri": redirectString]
    
        let headers: HTTPHeaders = ["Accept": "application/json"]
    
    
        guard let accessTokenURL = URL(string: accessTokenString) else {
            return
        }
        
        AF.request(accessTokenURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { (response) in
                if let responseJSON = response.value as? [String:Any],
                   let token = responseJSON["access_token"] as? String {
                    StorageService.setKeychainParameter(token, key: .token)
                    NotificationCenter.default.post(name: .loginSuccesfull, object: nil, userInfo: nil)
                }
            }
    
    }
}
