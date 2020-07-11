class RepositoryTableViewCellModel {
    private var repository: Repository
    
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
        return repository.languages
    }
    
    init(repo: Repository) {
        repository = repo
    }
    
    func loadFull(completion: @escaping (_ isError: Bool) -> Void) {
        if isLoaded {
            completion(false)
        }
        
        let requestString = "repos/​\(repository.fullName)".cleared
        let langRequestString = "repos/​\(repository.fullName)/languages".cleared
        
        NetworkService.requestDecodable(requestString, method: .get) { [weak self] (repository: Repository?, isError) in
            if let repo = repository {
                self?.repository = repo
            }
            NetworkService.request(langRequestString, method: .get, completion: { (languages, isError) in
                if let languages = languages {
                    self?.repository.languages = Array(languages.keys).joined(separator: ", ")
                    self?.isLoaded = true
                }
                completion(isError)
            })
        }
    }
}
