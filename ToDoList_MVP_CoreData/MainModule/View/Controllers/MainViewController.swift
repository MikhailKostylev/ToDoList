//
//  MainViewController.swift
//  ToDoList_MVP_CoreData
//
//  Created by Mikhail Kostylev on 27.05.2022.
//

import UIKit

protocol MainViewProtocol: AnyObject {
    func presentAlert(alert: UIAlertController)
    func refreshTable()
}

final class MainViewController: UIViewController, MainViewProtocol {

    var presenter: MainPresenterProtocol?

    private let tableView: UITableView = {
        let table = UITableView()
        return table
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupBarButton()
        setupRefreshControl()
        presenter?.getAllItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupVC()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.isHidden = false
        tableView.animateTableView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        tableView.isHidden = true
    }

    // MARK: - Setups

    private func setupVC() {
        title = "To Do List"
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            MainTableViewCell.self,
            forCellReuseIdentifier: MainTableViewCell.identifier
        )
        tableView.separatorStyle = .none
        tableView.rowHeight = 100
        tableView.sectionIndexColor = .secondaryLabel
    }

    private func setupBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(didTapAddButton)
        )
    }

    private func setupRefreshControl() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(
            self,
            action: #selector(didPullToRefresh),
            for: .valueChanged
        )
    }

    // MARK: - Actions

    @objc private func didTapAddButton() {
        presenter?.showCreateItemAlert()
    }

    @objc private func didPullToRefresh() {
        presenter?.getAllItems()
    }
    
    func presentAlert(alert: UIAlertController) {
        present(alert, animated: true)
    }

    func refreshTable() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
            self?.tableView.animateTableView()
            self?.tableView.refreshControl?.endRefreshing()
        }
    }
}

// MARK: - Table Methods

extension MainViewController: UITableViewDelegate, UITableViewDataSource {

    // Default

    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter?.items?.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell( withIdentifier: MainTableViewCell.identifier, for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
        guard let model = presenter?.items?[indexPath.section] else { return UITableViewCell() }
        cell.configure(with: model)
        return cell
    }

    // Index Titles

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return presenter?.items?[section].taskName?.prefix(1).capitalized
    }

    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        let alphabet = "abcdefghijklmnopqrstuvwxyz"
        return Array(alphabet.uppercased()).compactMap({ "\($0)" })
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        guard let targetIndex = presenter?.items?.firstIndex(where: { $0.taskName?.prefix(1).capitalized == title }) else {
            return 0
        }
        
        return targetIndex
    }

    // Selection

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let item = presenter?.items?[indexPath.section] else { return }
        presenter?.showDetailAllert(item: item)
    }

    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        guard let item = presenter?.items?[indexPath.section] else { return UIContextMenuConfiguration() }
        let config = UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil) { [weak self] _ in

                let showAction = UIAction(title: "Show Full", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in

                    self?.presenter?.showDetailVC(item: item)
                }

                let editAction = UIAction(title: "Edit", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in

                    self?.presenter?.showEditAlert(item: item)
                }

                let deleteAction = UIAction(title: "Delete", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, attributes: .destructive, state: .off) { _ in

                    self?.presenter?.deleteItem(item: item)
                }

                return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [showAction, editAction, deleteAction])
            }

        return config
    }
}
