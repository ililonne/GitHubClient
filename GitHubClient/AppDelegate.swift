//
//  AppDelegate.swift
//  GitHubClient
//
//  Created by Darya on 20.06.2020.
//  Copyright © 2020 ililonne. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if StorageService.getKeychainParameter(key: .token) != nil {
            window?.rootViewController = UIStoryboard.main.commonNavigationViewController
        } else {
            window?.rootViewController = UIStoryboard.main.loginViewController
        }
     
        window?.makeKeyAndVisible()
        
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
      
        LoginService.requestAuthToken(url: url)
      
        return true
    }
}

