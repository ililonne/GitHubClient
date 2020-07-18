//
//  TabBarController.swift
//  GitHubClient
//
//  Created by Darya on 18.07.2020.
//  Copyright © 2020 ililonne. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let publicVC = RepoListViewController(model: RepoListViewModel(type: .public), title: "Публичные репозитории")
        publicVC.tabBarItem.title = "Публичные"
        publicVC.tabBarItem.image = UIImage(named: "repos")
        
        let gitHubVC = RepoListViewController(model: RepoListViewModel(type: .github), title: "GitHub")
        gitHubVC.tabBarItem.title = "GitHub"
        gitHubVC.tabBarItem.image = UIImage(named: "github")
        
        setViewControllers([publicVC, gitHubVC], animated: false)
    }
}
