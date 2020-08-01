//
//  StorageService.swift
//  GitHubClient
//
//  Created by Darya on 21.06.2020.
//  Copyright © 2020 ililonne. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper
import CoreData

class StorageService {
    
    enum StorageKey: String {
        case token = "token"
    }
    
    @discardableResult
    class func setKeychainParameter(_ parameter: String, key: StorageKey) -> Bool {
        return KeychainWrapper.standard.set(parameter, forKey:  key.rawValue)
    }

    class func getKeychainParameter(key: StorageKey) -> String? {
        return KeychainWrapper.standard.string(forKey: key.rawValue)
    }

    class func clearParameteres() -> Bool {
        return KeychainWrapper.standard.removeObject(forKey: StorageKey.token.rawValue)
    }
    
    static let instance = StorageService()
    
    private init() {}
    
    func entityForName(_ entityName: String) -> NSEntityDescription {
        return NSEntityDescription.entity(forEntityName: entityName, in: persistentContainer.viewContext)!
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "RepoModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveRepositoryInfo(_ info: (Repository, [Commit])) throws {
        let repoObject = StorageObjectsConverter.objectFromRepository(info.0)
        let repoCommits = NSMutableOrderedSet()
        for commit in info.1 {
            let commitObject = StorageObjectsConverter.objectFromCommit(commit)
            repoCommits.add(commitObject)
        }
        repoObject.commits = repoCommits
        
        try saveContext()
    }
    
    func saveContext() throws {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            try context.save()
        }
    }
    
    func delete(object: RepositoryObject) throws {
        persistentContainer.viewContext.delete(object)
        try saveContext()
    }
    
    func findExistingRepositories(for repo: Repository) -> [RepositoryObject]? {
        let fetchRequest: NSFetchRequest<RepositoryObject> = RepositoryObject.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %d", repo.id)

        var results: [RepositoryObject] = []

        do {
            results = try StorageService.instance.persistentContainer.viewContext.fetch(fetchRequest)
        }
        catch {
            return nil
        }
        
        return results
    }
}
