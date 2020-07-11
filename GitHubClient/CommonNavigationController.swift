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

        let rightBarButton = UIBarButtonItem(image: UIImage(named: "logout"),
                                             style: .plain,
                                             target: self,
                                             action: #selector(logout))
        navigationBar.topItem?.rightBarButtonItem = rightBarButton
    }
    
    @objc private func logout() {
        if StorageService.clearParameteres() {
            UIApplication.shared.delegate?.window??.rootViewController = UIStoryboard.main.loginViewController
        }
    }
}
