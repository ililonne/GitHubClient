//
//  StorageObjectsConverter.swift
//  GitHubClient
//
//  Created by Darya on 01.08.2020.
//  Copyright © 2020 ililonne. All rights reserved.
//

import Foundation

let defaultIntConstantForSaving = -1

class StorageObjectsConverter {
    
    static func objectFromRepository(_ repo: Repository) -> RepositoryObject {
        let repoObject = RepositoryObject(entity: StorageService.instance.entityForName("RepositoryObject"),
                                          insertInto: StorageService.instance.persistentContainer.viewContext)
        repoObject.creationDate = repo.creationDate
        repoObject.descryption = repo.description
        repoObject.forks = Int32(repo.forks ?? defaultIntConstantForSaving)
        repoObject.fullName = repo.fullName
        repoObject.id = Int64(repo.id)
        repoObject.language = repo.language
        repoObject.name = repo.name
        repoObject.ownerAvatarUrl = repo.owner.avatarUrl
        repoObject.ownerName = repo.owner.name
        repoObject.stars = Int32(repo.stars ?? defaultIntConstantForSaving)
        repoObject.watchers = Int32(repo.watchers ?? defaultIntConstantForSaving)
        repoObject.addingDate = Date()
    
        return repoObject
    }
    
    static func repositoryFromObject(_ object: RepositoryObject) -> Repository? {
        if let ownerName = object.ownerName,
           let name = object.name,
           let fullName = object.fullName {
               let owner = Owner(name: ownerName, avatarUrl: object.ownerAvatarUrl)
               return Repository(id: Int(object.id),
                                 name: name,
                                 fullName: fullName,
                                 owner: owner,
                                 description: object.descryption,
                                 forks: Int(object.forks),
                                 stars: Int(object.stars),
                                 watchers: Int(object.watchers),
                                 language: object.language,
                                 creationDate: object.creationDate)
        }
        return nil
    }
    
    static func objectFromCommit(_ commit: Commit) -> CommitObject {
        let commitObject = CommitObject(entity:  StorageService.instance.entityForName("CommitObject"),
                                        insertInto:  StorageService.instance.persistentContainer.viewContext)
        commitObject.message = commit.message
        commitObject.date = commit.date
        commitObject.authorName = commit.author.name
        commitObject.authorAvatarUrl = commit.author.avatarUrl
        return commitObject
    }

    static func commitFromObject(_ object: CommitObject) -> Commit? {
        if let authorName = object.authorName,
           let message = object.message,
           let date = object.date {
                return Commit(message: message,
                              date: date,
                              author: Owner(name: authorName,
                                            avatarUrl: object.authorAvatarUrl))
        }
        return nil
    }
}
