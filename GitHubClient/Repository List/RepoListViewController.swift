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

    private let model: RepoListViewModel
    private lazy var loadIndicator = UIActivityIndicatorView(style: .gray)
    
    private lazy var bottomLoader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView(style: .gray)
        loader.hidesWhenStopped = true

        return loader
    }()
    
    init(model: RepoListViewModel, title: String) {
        self.model = model
        super.init(style: .plain)
        self.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib.init(nibName: "RepositoryTableViewCell", bundle: .main), forCellReuseIdentifier: "RepositoryTableViewCell")

        tableView.rowHeight = UITableView.automaticDimension
        model.delegate = self
        
        loadIndicator.hidesWhenStopped = true
        view.addSubview(loadIndicator)
        loadIndicator.snp.makeConstraints({ $0.center.equalToSuperview() })
        loadIndicator.startAnimating()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        tableView.tableFooterView = bottomLoader
        
        model.update()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.topItem?.title = title
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
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let isLastCell = indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1
        if isLastCell && model.isNeedLoadMore {
            bottomLoader.startAnimating()
            model.update()
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        guard let repo = model.getRepoModel(for: indexPath.row)?.repository else {
            assertionFailure()
            return nil
        }
        
        if let results = StorageService.instance.findExistingRepositories(for: repo),
           results.count > 0 {
            let deleteAction = UITableViewRowAction(style: .normal, title: "Удалить из избранного") { (action, indexPath) in
                for result in results {
                    do {
                        try StorageService.instance.delete(object: result)
                    }
                    catch {
                        //
                    }
                }
            }
            deleteAction.backgroundColor = .red
            return [deleteAction]
        }
        else {
            let favoriteAction = UITableViewRowAction(style: .normal, title: "Сохранить") { [weak self] (action, indexPath) in
                self?.model.loadAndSaveFullRepository(repo)
            }
            favoriteAction.backgroundColor = .green
            return [favoriteAction]
        }
    }
    
    @objc private func refresh() {
        model.refresh()
    }
}

extension RepoListViewController: RepoListViewModelDelegate {
    func viewModelDidLoad() {
        DispatchQueue.main.async {
            if self.loadIndicator.isAnimating {
                self.loadIndicator.stopAnimating()
            }
            if self.tableView.refreshControl?.isRefreshing == true {
                self.tableView.refreshControl?.endRefreshing()
            }
            self.tableView.reloadData()
            if !self.model.isNeedLoadMore {
                self.bottomLoader.stopAnimating()
            }
        }
    }
    
    func viewModelDidFailLoad() {
        //
    }
    
    func viewModelDidFailLoadFullRepo() {
        //
    }
}
