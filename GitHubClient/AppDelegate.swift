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
        
        if StorageService.userIsLogged {
            window?.rootViewController = UIStoryboard.main.tabBarController
        } else {
            StorageService.clearParameteres()
            window?.rootViewController = UIStoryboard.main.loginViewController
        }
     
        window?.makeKeyAndVisible()
        
        return true
    }
}

