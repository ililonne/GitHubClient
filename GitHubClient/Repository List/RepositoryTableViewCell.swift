//
//  RepositoryTableViewCell.swift
//  GitHubClient
//
//  Created by Darya on 21.06.2020.
//  Copyright © 2020 ililonne. All rights reserved.
//

import UIKit
import Kingfisher

class RepositoryTableViewCell: UITableViewCell {

    @IBOutlet weak var repoTitleLabel: UILabel!
    @IBOutlet weak var startCountLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var forkCountLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ownerAvatarImageView: UIImageView!
    @IBOutlet weak var ownerNameLabel: UILabel!
    
    private var model: RepositoryTableViewCellModel?

    override func prepareForReuse() {
        super.prepareForReuse()
        startCountLabel.text = ""
        forkCountLabel.text = ""
        languageLabel.text = ""
    }
    
    func update(with model: RepositoryTableViewCellModel) {
        self.model = model
        
        repoTitleLabel.text = model.repoTitle
        descriptionLabel.text = model.description
        ownerNameLabel.text = model.ownerName
        
        if let avatarUrlString = model.avatarUrlString, let avatarUrl = URL(string: avatarUrlString) {
            
            ownerAvatarImageView.kf.setImage(with: avatarUrl, placeholder: UIImage(named: "avatar"))
        }
        if let starsText = model.starsCount,
           let forksText = model.forksCount,
           let languageText = model.languages {
               startCountLabel.text = starsText
               forkCountLabel.text = forksText
               languageLabel.text = languageText
        } else {
            model.loadFull(completion: { [weak self] (isError) in
                DispatchQueue.main.async {
                    
                    if isError {
                        self?.startCountLabel.text = "Ошибка"
                        self?.forkCountLabel.text = "Ошибка"
                        self?.languageLabel.text = "Ошибка"
                    } else {
                        self?.startCountLabel.text = self?.model?.starsCount ?? "0"
                        self?.forkCountLabel.text = self?.model?.forksCount ?? "0"
                        self?.languageLabel.text = self?.model?.languages
                    }
                }
            })
        }
    }
}
