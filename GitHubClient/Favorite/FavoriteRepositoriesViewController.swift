//
//  FavoriteRepositoriesViewController.swift
//  GitHubClient
//
//  Created by Darya on 01.08.2020.
//  Copyright © 2020 ililonne. All rights reserved.
//

import UIKit
import CoreData

class FavoriteRepositoriesViewController: TableViewController {
    
    private lazy var emptyViewLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont(name: "Helvetica", size: 18)
        l.textAlignment = .center
        l.text = "Нет избранных репозиториев"
        l.isHidden = true
        return l
    }()

    private lazy var fetchedResultsController: NSFetchedResultsController<RepositoryObject> = {
        let fetchRequest: NSFetchRequest<RepositoryObject> = RepositoryObject.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "addingDate", ascending: true)]
        let managedObjectContext = StorageService.instance.persistentContainer.viewContext
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: managedObjectContext,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        return fetchedResultsController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchedResultsController.delegate = self
        update()
        
        tableView.register(UINib.init(nibName: "RepositoryTableViewCell", bundle: .main), forCellReuseIdentifier: "RepositoryTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        
        view.addSubview(emptyViewLabel)
        NSLayoutConstraint.activate([
            emptyViewLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyViewLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        updateEmptyView()
        
        title = "Избранное"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryTableViewCell", for: indexPath) as? RepositoryTableViewCell {
            let object = fetchedResultsController.object(at: indexPath)
            if let repo = StorageObjectsConverter.repositoryFromObject(object) {
                cell.update(with: RepositoryTableViewCellModel(repo: repo))
            }
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = fetchedResultsController.object(at: indexPath)
        if let repo = StorageObjectsConverter.repositoryFromObject(object) {
            let model: RepositoryViewModel
            if let commits = object.commits?.compactMap({ $0 as? CommitObject }) {
                model = RepositoryViewModel(repo: repo, commits: commits.compactMap({
                    StorageObjectsConverter.commitFromObject($0)
                }))
            } else {
                model = RepositoryViewModel(repo: repo)
            }
            let vc = RepositoryViewController(model: model)
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let managedObject = fetchedResultsController.object(at: indexPath)
            do {
                try StorageService.instance.delete(object: managedObject)
            }
            catch {
                showErrorAlert(message: "Не удалось удалить репозиторий")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Удалить"
    }
    
    override func update() {
        super.update()
        do {
            try fetchedResultsController.performFetch()
            loadIndicator.stopAnimating()
            loadIndicator.isHidden = true
        } catch {
            showError()
        }
    }
    
    private func updateEmptyView() {
        let fetchedObjectsCount = fetchedResultsController.fetchedObjects?.count ?? 0
        emptyViewLabel.isHidden = fetchedObjectsCount > 0
    }
}

extension FavoriteRepositoriesViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        default:
            break
        }
        updateEmptyView()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
