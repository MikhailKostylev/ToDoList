//
//  DetailController.swift
//  ToDoList_MVP_CoreData
//
//  Created by Mikhail Kostylev on 29.05.2022.
//

import UIKit

protocol DetailViewProtocol: AnyObject {
    func configure(with item: MainItem)
    func didTapCloseButton()
}

final class DetailViewController: UIViewController, DetailViewProtocol {
    
    var presenter: DetailPresenterProtocol?

    // MARK: - UI elements

    let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabels()
        setupCloseButton()
        presenter?.configureLabels()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupVC()
    }

    // MARK: - Setups

    private func setupVC() {
        view.backgroundColor = .secondarySystemBackground
        navigationController?.navigationBar.tintColor = .label
    }

    private func setupLabels() {
        view.addSubview(nameLabel)
        view.addSubview(dateLabel)

        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nameLabel.topAnchor.constraint(equalTo: view.topAnchor),
            nameLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8),

            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupCloseButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(didTapCloseButton)
        )
    }
    
    @objc func didTapCloseButton() {
        presenter?.backToRootVC()
    }

    // MARK: - Configure

    public func configure(with item: MainItem) {
        nameLabel.text = item.taskName
        dateLabel.text = item.createdAt?.toString()
    }
}
