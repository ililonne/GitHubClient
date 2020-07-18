//
//  RepoListViewController.swift
//  GitHubClient
//
//  Created by Darya on 21.06.2020.
//  Copyright © 2020 ililonne. All rights reserved.
//

import UIKit
import SnapKit

class RepoListViewController: UITableViewController {

    private let model = RepoListViewModel()
    
    private lazy var loadIndicator = UIActivityIndicatorView(style: .gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        model.delegate = self
        
        loadIndicator.hidesWhenStopped = true
        view.addSubview(loadIndicator)
        loadIndicator.snp.makeConstraints({ $0.center.equalToSuperview() })
        loadIndicator.startAnimating()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        model.update()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.numberOfItems
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryTableViewCell", for: indexPath) as? RepositoryTableViewCell,
           let model = model.getRepoModel(for: indexPath.row) {
                cell.update(with: model)
                return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let model = model.getRepoModel(for: indexPath.row) {
            let vc = RepositoryViewController(model: RepositoryViewModel(repo: model.repository))
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc private func refresh() {
        model.update()
    }
}

extension RepoListViewController: ViewModelDelegate {
    func viewModelDidLoad() {
        if loadIndicator.isAnimating {
            loadIndicator.stopAnimating()
        }
        if tableView.refreshControl?.isRefreshing == true {
            tableView.refreshControl?.endRefreshing()
        }
        tableView.reloadData()
    }
    
    func viewModelDidFailLoad() {
        //
    }
}
