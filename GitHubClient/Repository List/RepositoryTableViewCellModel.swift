import Foundation

class RepositoryTableViewCellModel {
    private(set) var repository: Repository
    
    private var isLoaded = false
    
    var repoTitle: String {
        return repository.name
    }
    var description: String? {
        return repository.description
    }
    var ownerName: String {
        return repository.owner.name
    }
    var avatarUrlString: String? {
        return repository.owner.avatarUrl
    }
    var starsCount: String {
        return String(repository.stars ?? 0)
    }
    var forksCount: String {
        return String(repository.forks ?? 0)
    }
    var languages: String? {
        return repository.language
    }
    
    init(repo: Repository) {
        repository = repo
    }
    
    func loadFull(completion: @escaping (_ isError: Bool) -> Void) {
        if isLoaded {
            completion(false)
        }
        
        let requestString = "repos/​\(repository.fullName)".cleared
        DispatchQueue.global(qos: .utility).async {
            NetworkService.request(requestString) { [weak self] (json, isError) in
                if let repoDict = json as? [String: Any],
                   let repo = Parser.parseRepository(from: repoDict) {
                        self?.repository = repo
                        self?.isLoaded = true
                    }
                    completion(isError)
            }
        }
    }
}