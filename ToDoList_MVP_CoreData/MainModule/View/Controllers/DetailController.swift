//
//  DetailController.swift
//  ToDoList_MVP_CoreData
//
//  Created by Mikhail Kostylev on 27.05.2022.
//

import UIKit

protocol DetailViewControllerProtocol: AnyObject {
    func configure(with item: MainItem)
}

final class DetailViewController: UIViewController, DetailViewControllerProtocol {
        
    //MARK: - UI elements
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        button.tintColor = .secondaryLabel
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
        setupLabels()
        setupCloseButton()
    }
    
    //MARK: - Setups
    
    private func setupVC() {
        view.backgroundColor = .secondarySystemBackground
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func setupLabels() {
        view.addSubview(nameLabel)
        view.addSubview(dateLabel)
        view.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nameLabel.topAnchor.constraint(equalTo: view.topAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            closeButton.heightAnchor.constraint(equalToConstant: 50),
            closeButton.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupCloseButton() {
        closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
    }
    
    @objc private func didTapCloseButton() {
        dismiss(animated: true)
    }
    
    //MARK: - Configure
    
    public func configure(with item: MainItem) {
        nameLabel.text = item.taskName
        dateLabel.text = item.createdAt?.toString()
    }
}
