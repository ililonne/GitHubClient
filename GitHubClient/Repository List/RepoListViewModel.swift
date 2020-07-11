//
//  RepoListViewModel.swift
//  GitHubClient
//
//  Created by Darya on 21.06.2020.
//  Copyright © 2020 ililonne. All rights reserved.
//

import Foundation

protocol RepoListViewModelDelegate: class {
    func viewModelDidLoad()
    func viewModelDidFailLoad()
}

class RepoListViewModel {
    weak var delegate: RepoListViewModelDelegate?
    
    private var repositories = [RepositoryTableViewCellModel]()
    
    var numberOfItems: Int {
        return repositories.count
    }
    
    func update() {
        NetworkService.requestDecodable("repositories", method: .get) { [weak self] (repositories: [Repository]?, isError) in
            guard let this = self else {
                return
            }
            if isError {
                this.delegate?.viewModelDidFailLoad()
            } else {
                if let repos = repositories {
                    this.repositories = repos.map({
                        RepositoryTableViewCellModel(repo: $0)
                    })
                }
                this.delegate?.viewModelDidLoad()
            }
        }
    }
    
    func getRepoModel(for row: Int) -> RepositoryTableViewCellModel? {
        if row > 0 && row < repositories.count {
            return repositories[row]
        }
        return nil
    }
}
