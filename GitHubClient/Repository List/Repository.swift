//
//  Repository.swift
//  GitHubClient
//
//  Created by Darya on 21.06.2020.
//  Copyright © 2020 ililonne. All rights reserved.
//

struct Repository: Decodable {
    let name: String
    let fullName: String
    let owner: Owner
    let description: String?
    let forks: Int?
    let stars: Int?
    var languages: String?

  enum CodingKeys: String, CodingKey {
    case name
    case fullName = "full_name"
    case owner
    case description
    case stars = "stargazers_count"
    case forks
  }
}
