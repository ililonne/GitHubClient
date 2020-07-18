//
//  CommonNavigationController.swift
//  GitHubClient
//
//  Created by Darya on 11.07.2020.
//  Copyright © 2020 ililonne. All rights reserved.
//

import UIKit

class CommonNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let logoutButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        logoutButton.setImage(UIImage(named: "logout"), for: .normal)
        logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
        navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(customView: logoutButton)
    }
    
    @objc private func logout() {
        if StorageService.clearParameteres() {
            UIApplication.shared.delegate?.window??.rootViewController = UIStoryboard.main.loginViewController
        }
    }
}
