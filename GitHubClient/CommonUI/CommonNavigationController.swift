//
//  CommonNavigationController.swift
//  GitHubClient
//
//  Created by Darya on 11.07.2020.
//  Copyright © 2020 ililonne. All rights reserved.
//

import UIKit

class CommonNavigationController: UINavigationController {

    private lazy var logoutButton: UIButton = {
        let b = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        b.setImage(UIImage(named: "logout"), for: .normal)
        b.addTarget(self, action: #selector(logout), for: .touchUpInside)
        return b
    }()

    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        rootViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: logoutButton)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func logout() {
        if StorageService.clearParameteres() {
            UIApplication.shared.delegate?.window??.rootViewController = UIStoryboard.main.loginViewController
        }
    }
}
