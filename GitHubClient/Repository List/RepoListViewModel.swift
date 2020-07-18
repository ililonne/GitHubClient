//
//  RepoListViewModel.swift
//  GitHubClient
//
//  Created by Darya on 21.06.2020.
//  Copyright © 2020 ililonne. All rights reserved.
//

import Foundation

protocol ViewModelDelegate: class {
    func viewModelDidLoad()
    func viewModelDidFailLoad()
}

class RepoListViewModel {
    weak var delegate: ViewModelDelegate?
    
    private var repositories = [RepositoryTableViewCellModel]()
    
    var numberOfItems: Int {
        return repositories.count 
    }
    
    func update() {
        NetworkService.request("repositories") { [weak self] (json, isError) in
            if isError {
                self?.delegate?.viewModelDidFailLoad()
            } else {
                if let jsonArray = json as? [[String: Any]] {
                    let repos = jsonArray.compactMap({ Parser.parseRepository(from: $0) })
                    self?.repositories = repos.map({
                        RepositoryTableViewCellModel(repo: $0)
                    })
                    self?.delegate?.viewModelDidLoad()
                } else {
                    self?.delegate?.viewModelDidFailLoad()
                }
            }
        }
    }
    
    func getRepoModel(for row: Int) -> RepositoryTableViewCellModel? {
        if row < repositories.count {
            return repositories[row]
        }
        return nil
    }
}
