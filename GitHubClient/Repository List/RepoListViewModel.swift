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

enum RepoListViewModelType {
    case `public`
    case github
}

class RepoListViewModel {
    weak var delegate: ViewModelDelegate?
    
    private let type: RepoListViewModelType
    
    private var repositories = [RepositoryTableViewCellModel]()
    private(set) var isNeedLoadMore = true
    private(set) var isUpdating = false
    private var lastRepoID = 0
    private var page = 0
    
    var numberOfItems: Int {
        return repositories.count 
    }
    
    init(type: RepoListViewModelType) {
        self.type = type
    }
    
    private var parameters: [String: Any]? {
        switch type {
        case .public:
            if isNeedLoadMore && page > 0 {
                return ["since": lastRepoID]
            }
            return nil
            
        case .github:
            if isNeedLoadMore && page > 0 {
                return ["page": page + 1]
            }
            return nil
        }
    }
    
    private var request: String {
        switch type {
        case .public:
            return "repositories"
            
        case .github:
            return "orgs/github/repos"
        }
    }
    
    func update() {
        if isUpdating {
            return
        }
        
        isUpdating = true
        
        DispatchQueue.global(qos: .utility).async {
            NetworkService.request(self.request, parameters: self.parameters) { [weak self] (json, isError) in
                guard let this = self else {
                    return
                }
                if isError {
                    this.delegate?.viewModelDidFailLoad()
                } else {
                    if let jsonArray = json as? [[String: Any]] {
                        let repos = jsonArray.compactMap({ Parser.parseRepository(from: $0) })
                        if let last = repos.last {
                            this.lastRepoID = last.id
                        } else {
                            this.isNeedLoadMore = false
                        }
                        let models = repos.map({
                            RepositoryTableViewCellModel(repo: $0)
                        })
                        if this.page > 0 {
                            this.repositories += models
                        } else {
                            this.repositories = models
                        }
                        this.page += 1
                        this.isUpdating = false
                        this.delegate?.viewModelDidLoad()
                    } else {
                        this.isUpdating = false
                        this.delegate?.viewModelDidFailLoad()
                    }
                }
            }
        }
    }
    
    func refresh() {
        if isUpdating {
            return
        }
        isNeedLoadMore = true
        page = 0
        lastRepoID = 0
        update()
    }
    
    func getRepoModel(for row: Int) -> RepositoryTableViewCellModel? {
        if row < repositories.count {
            return repositories[row]
        }
        return nil
    }
}
