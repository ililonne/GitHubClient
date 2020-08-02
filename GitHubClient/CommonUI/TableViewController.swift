//
//  TableViewController.swift
//  GitHubClient
//
//  Created by Darya on 02.08.2020.
//  Copyright © 2020 ililonne. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    lazy var loadIndicator = UIActivityIndicatorView(style: .gray)

    private lazy var errorView: UIView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fillProportionally
        sv.spacing = 20
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.isHidden = true
        
        let label = UILabel()
        label.font = UIFont(name: "Helvetica", size: 18)
        label.textAlignment = .center
        label.text = "Произошла ошибка"
        sv.addArrangedSubview(label)
        
        let button = UIButton()
        button.clipsToBounds = true
        button.layer.cornerRadius = 4
        button.setTitle("Обновить", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(update), for: .touchUpInside)
        sv.addArrangedSubview(button)
        
        return sv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadIndicator)
        
        view.addSubview(errorView)
        NSLayoutConstraint.activate([
            loadIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            errorView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30)
        ])
        
        loadIndicator.startAnimating()
    }

    func showError() {
        loadIndicator.stopAnimating()
        loadIndicator.isHidden = true
        errorView.isHidden = false
    }

    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "Ок", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    @objc func update() {
        if !loadIndicator.isAnimating {
            loadIndicator.startAnimating()
            loadIndicator.isHidden = false
        }
        errorView.isHidden = true
    }
}
