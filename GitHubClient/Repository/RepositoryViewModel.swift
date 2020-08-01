//
//  RepositoryViewModel.swift
//  GitHubClient
//
//  Created by Darya on 12.07.2020.
//  Copyright © 2020 ililonne. All rights reserved.
//

import Foundation

let maxCommitCount = 10

class RepositoryViewModel {
    
    weak var delegate: ViewModelDelegate?
    
    private(set) var repository: Repository
    private var commits = [Commit]()
    
    private var isLoaded = false
    
    var numberOfItems: Int {
        return commits.count
    }

    init(repo: Repository) {
        repository = repo
        isLoaded = repo.stars != nil &&
                   repo.forks != nil &&
                   repo.watchers != nil &&
                   repo.stars != defaultIntConstantForSaving &&
                   repo.forks != defaultIntConstantForSaving &&
                   repo.watchers != defaultIntConstantForSaving
    }

    convenience init(repo: Repository, commits: [Commit]) {
        self.init(repo: repo)
        self.commits = commits
    }
    
    func update() {
        guard commits.isEmpty else {
            delegate?.viewModelDidLoad()
            return
        }
        
        let request = "repos/​\(repository.fullName)/commits".cleared
        let langRequestString = "repos/​\(repository.fullName)/languages".cleared
        
        DispatchQueue.global(qos: .utility).async {
            
            NetworkService.request(langRequestString, completion: { [weak self] (json, isError) in
                if let languages = json as? [String: Any] {
                    self?.repository.language = Array(languages.keys).joined(separator: ", ")
                }
                NetworkService.request(request) { (json, isError) in
                    if let jsonArray = json as? [[String: Any]] {
                        self?.commits = Parser.parseCommits(from: jsonArray, maxCount: maxCommitCount)
                        self?.delegate?.viewModelDidLoad()
                    } else {
                        self?.delegate?.viewModelDidFailLoad()
                    }
                }
            })
        }
    }
    
    func getCommit(for row: Int) -> Commit? {
        if row < commits.count {
            return commits[row]
        }
        return nil
    }
}
