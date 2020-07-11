//
//  LoginViewController.swift
//  GitHubClient
//
//  Created by Darya on 20.06.2020.
//  Copyright © 2020 ililonne. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(showMainScreen), name: .loginSuccesfull, object: nil)
    }
    
    @IBAction func login(_ sender: Any) {
        LoginService.requestAuthorization()
    }
    
    @objc private func showMainScreen() {
        NotificationCenter.default.removeObserver(self)
        
        UIApplication.shared.delegate?.window??.rootViewController = UIStoryboard.main.commonNavigationViewController
    }
}

