//
//  Repository.swift
//  GitHubClient
//
//  Created by Darya on 21.06.2020.
//  Copyright © 2020 ililonne. All rights reserved.
//
import Foundation

struct Repository {
    let id: Int
    let name: String
    let fullName: String
    let owner: Owner
    let description: String?
    let forks: Int?
    let stars: Int?
    let watchers: Int?
    var language: String?
    let creationDate: String?
}
