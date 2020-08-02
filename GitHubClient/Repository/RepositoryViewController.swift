//
//  RepositoryViewController.swift
//  GitHubClient
//
//  Created by Darya on 12.07.2020.
//  Copyright © 2020 ililonne. All rights reserved.
//

import UIKit

class RepositoryViewController: TableViewController {

    private let model: RepositoryViewModel

    private lazy var headerView: RepositoryHeaderView? = {
        let nib = UINib.init(nibName: "RepositoryHeaderView", bundle: .main)
        let view = nib.instantiate(withOwner: nil, options: nil).first as? RepositoryHeaderView
        view?.isHidden = true
        return view
    }()
    
    required init(model: RepositoryViewModel) {
        self.model = model
        super.init(style: .plain)
        self.model.delegate = self
        
        title = model.repository.fullName
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableHeaderView = headerView
        tableView.tableFooterView = UIView()
        
        tableView.register(UINib.init(nibName: "CommitTableViewCell", bundle: .main), forCellReuseIdentifier: "CommitTableViewCell")
        
        model.update()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let headerView = tableView.tableHeaderView else {
          return
        }
        let size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        if headerView.frame.size.height != size.height {
            headerView.frame.size.height = size.height
        }
        tableView.layoutIfNeeded()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.numberOfItems
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommitTableViewCell", for: indexPath) as? CommitTableViewCell
        if let commit = model.getCommit(for: indexPath.row) {
            cell?.update(with: commit)
        }
        return cell ?? UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }

    override func update() {
        super.update()
        model.update()
    }
}

extension RepositoryViewController: ViewModelDelegate {
    func viewModelDidLoad() {
        DispatchQueue.main.async {
            if self.loadIndicator.isAnimating {
                self.loadIndicator.stopAnimating()
                self.loadIndicator.isHidden = true
            }
            self.headerView?.isHidden = false
            self.headerView?.update(with: self.model.repository)
            self.tableView.reloadData()
            self.viewDidLayoutSubviews()
        }
    }
    
    func viewModelDidFailLoad() {
        showError()
    }
}
