//
//  Parser.swift
//  GitHubClient
//
//  Created by Darya on 18.07.2020.
//  Copyright © 2020 ililonne. All rights reserved.
//

class Parser {
    class func parseRepository(from json: [String: Any]) -> Repository? {
        if let name = json["name"] as? String,
           let fullName = json["full_name"] as? String,
           let ownerDict = json["owner"] as? [String: Any],
           let owner = parseOwner(from: ownerDict) {
            
            return Repository(name: name,
                              fullName: fullName,
                              owner: owner,
                              description: json["description"] as? String,
                              forks: json["forks"] as? Int,
                              stars: json["stargazers_count"] as? Int,
                              watchers: json["watchers"] as? Int,
                              language: json["language"] as? String,
                              date: json["created_at"] as? String)
        }
        return nil
    }
    
    class func parseOwner(from json: [String: Any]) -> Owner? {
        if let name = json["login"] as? String {
            return Owner(name: name,
                         avatarUrl: json["avatar_url"] as? String)
        }
        return nil
    }
    
    class func parseCommit(from json: [String: Any]) -> Commit? {
        if let commitInfo = json["commit"] as? [String: Any],
           let message = commitInfo["message"] as? String {
            
            var date: String?
            
            if let commiter = commitInfo["committer"] as? [String: Any],
               let dateStr = commiter["date"] as? String {
                date = dateStr
                
            } else if let authorDict = commitInfo["author"] as? [String: Any],
                      let dateStr = authorDict["date"] as? String{
                date = dateStr
            }
            
            var author: Owner?
            
            if let authorDict = json["author"] as? [String: Any],
               let owner = parseOwner(from: authorDict) {
                author = owner
                
            } else if let authorDict = json["committer"] as? [String: Any],
                      let owner = parseOwner(from: authorDict) {
                author = owner
                
            } else if let authorDict = commitInfo["author"] as? [String: Any],
                      let name = authorDict["name"] as? String{
                author = Owner(name: name, avatarUrl: nil)
                
            } else if let authorDict = commitInfo["committer"] as? [String: Any],
                      let name = authorDict["name"] as? String{
                author = Owner(name: name, avatarUrl: nil)
            }
            
            if let unwrapDate = date, let unwrapAuthor = author {
                return Commit(message: message, date: unwrapDate, author: unwrapAuthor)
            }
            
            return nil
        }
        return nil
    }
}