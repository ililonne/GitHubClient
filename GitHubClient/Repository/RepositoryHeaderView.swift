//
//  RepositoryHeaderView.swift
//  GitHubClient
//
//  Created by Darya on 12.07.2020.
//  Copyright © 2020 ililonne. All rights reserved.
//

import UIKit

class RepositoryHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var watchersLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var forksLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ownerAvatarImageView: UIImageView!
    @IBOutlet weak var ownerNameLabel: UILabel!
    @IBOutlet weak var createdDateLabel: UILabel!
    
    private let formatter = StringDateFormatter()
    
    func update(with repo: Repository) {
        watchersLabel.text = String(repo.watchers ?? 0)
        starsLabel.text = String(repo.stars ?? 0)
        forksLabel.text = String(repo.forks ?? 0)
        titleLabel.text = repo.name
        languageLabel.text = repo.language
        descriptionLabel.text = repo.description
        ownerNameLabel.text = repo.owner.name
        createdDateLabel.text = formatter.stringDate(from: repo.creationDate ?? "")
        titleLabel.text = repo.name
        
        if let avatarUrlString = repo.owner.avatarUrl, let avatarUrl = URL(string: avatarUrlString) {
            ownerAvatarImageView.kf.setImage(with: avatarUrl, placeholder: UIImage(named: "avatar"))
        }
    }
}
