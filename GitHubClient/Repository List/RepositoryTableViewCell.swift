//
//  RepositoryTableViewCell.swift
//  GitHubClient
//
//  Created by Darya on 21.06.2020.
//  Copyright © 2020 ililonne. All rights reserved.
//

import UIKit
import Kingfisher
import SkeletonView

class RepositoryTableViewCell: UITableViewCell {

    @IBOutlet weak var repoTitleLabel: UILabel!
    @IBOutlet weak var startCountLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var forkCountLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ownerAvatarImageView: UIImageView!
    @IBOutlet weak var ownerNameLabel: UILabel!
    
    private var model: RepositoryTableViewCellModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        showSkeletonAnimation()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        startCountLabel.text = ""
        forkCountLabel.text = ""
        languageLabel.text = ""
        showSkeleton()
        showSkeletonAnimation()
    }
    
    func update(with model: RepositoryTableViewCellModel) {
        self.model = model
        
        repoTitleLabel.text = model.repoTitle
        descriptionLabel.text = model.description
        ownerNameLabel.text = model.ownerName
        
        if let avatarUrlString = model.avatarUrlString, let avatarUrl = URL(string: avatarUrlString) {
            
            ownerAvatarImageView.kf.setImage(with: avatarUrl, placeholder: UIImage(named: "avatar"))
        }
        model.loadFull(completion: { [weak self] (isError) in
            DispatchQueue.main.async {
                self?.hideSkeleton()
                
                if isError {
                    self?.startCountLabel.text = "Ошибка"
                    self?.forkCountLabel.text = "Ошибка"
                    self?.languageLabel.text = "Ошибка"
                } else {
                    self?.startCountLabel.text = self?.model?.starsCount
                    self?.forkCountLabel.text = self?.model?.forksCount
                    self?.languageLabel.text = self?.model?.languages
                }
            }
        })
    }
    
    private func showSkeleton() {
        startCountLabel.showSkeleton()
        forkCountLabel.showSkeleton()
        languageLabel.showSkeleton()
    }
    
    private func showSkeletonAnimation() {
        startCountLabel.showAnimatedSkeleton()
        forkCountLabel.showAnimatedSkeleton()
        languageLabel.showAnimatedSkeleton()
    }
    
    private func hideSkeleton() {
        startCountLabel.hideSkeleton()
        forkCountLabel.hideSkeleton()
        languageLabel.hideSkeleton()
    }
}
