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

        let publicVC = CommonNavigationController(rootViewController: RepoListViewController(model: RepoListViewModel(type: .public), title: "Публичные репозитории"))
        publicVC.tabBarItem.title = "Публичные"
        publicVC.tabBarItem.image = UIImage(named: "repos")
        
        let gitHubVC = CommonNavigationController(rootViewController: RepoListViewController(model: RepoListViewModel(type: .github), title: "GitHub"))
        gitHubVC.tabBarItem.title = "GitHub"
        gitHubVC.tabBarItem.image = UIImage(named: "github")

        let favoriteVC = CommonNavigationController(rootViewController: FavoriteRepositoriesViewController())
        favoriteVC.tabBarItem.title = "Избранное"
        favoriteVC.tabBarItem.image = UIImage(named: "fav")
        
        setViewControllers([publicVC, gitHubVC, favoriteVC], animated: false)
    }
}
