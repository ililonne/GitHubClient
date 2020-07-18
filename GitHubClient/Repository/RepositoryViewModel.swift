//
//  RepositoryViewModel.swift
//  GitHubClient
//
//  Created by Darya on 12.07.2020.
//  Copyright © 2020 ililonne. All rights reserved.
//

import Foundation

private let commitCount = 10

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
    }
    
    func update() {
        let request = "repos/​\(repository.fullName)/commits".cleared
        let langRequestString = "repos/​\(repository.fullName)/languages".cleared
        
        DispatchQueue.global(qos: .utility).async {
            
            NetworkService.request(langRequestString, completion: { [weak self] (json, isError) in
                if let languages = json as? [String: Any] {
                    self?.repository.language = Array(languages.keys).joined(separator: ", ")
                }
                NetworkService.request(request) { (json, isError) in
                    if let jsonArray = json as? [[String: Any]] {
                        let commits = jsonArray.compactMap({ Parser.parseCommit(from: $0) })
                        if commits.count > commitCount {
                            self?.commits = Array(commits[0..<commitCount])
                        } else {
                            self?.commits = commits
                        }
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
