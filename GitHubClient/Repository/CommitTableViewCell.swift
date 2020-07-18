//
//  CommitTableViewCell.swift
//  GitHubClient
//
//  Created by Darya on 12.07.2020.
//  Copyright © 2020 ililonne. All rights reserved.
//

import UIKit
import Kingfisher

class CommitTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var authorAvatarImageView: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    
    private let formatter = StringDateFormatter()

    func update(with commit: Commit) {
        titleLabel.text = commit.message
        dateLabel.text = formatter.stringDate(from: commit.date)
        
        if let avatarURLString = commit.author.avatarUrl, let avatarUrl = URL(string: avatarURLString) {
            authorAvatarImageView.kf.setImage(with: avatarUrl, placeholder: UIImage(named: "avatar"))
        } else {
            authorAvatarImageView.image = UIImage(named: "avatar")
        }
        authorNameLabel.text = commit.author.name
    }
}
