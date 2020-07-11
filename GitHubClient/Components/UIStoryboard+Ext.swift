//
//  UIStoryboard+Ext.swift
//  GitHubClient
//
//  Created by Darya on 11.07.2020.
//  Copyright © 2020 ililonne. All rights reserved.
//

import UIKit

extension UIStoryboard {
    static var main: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    var commonNavigationViewController: UIViewController {
        return instantiateViewController(withIdentifier: "CommonNavigationController")
    }
    
    var loginViewController: UIViewController {
        return instantiateViewController(withIdentifier: "LoginViewController")
    }
}
