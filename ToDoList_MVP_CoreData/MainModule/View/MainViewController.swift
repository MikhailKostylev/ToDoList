//
//  MainViewController.swift
//  ToDoList_MVP_CoreData
//
//  Created by Mikhail Kostylev on 27.05.2022.
//

import UIKit

class MainViewController: UIViewController, MainPresenterInput {
    
    var output: MainPresenterOutput!
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var items = [MainItem]()
    
    private let tableView: UITableView = {
        let table = UITableView()
        return table
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupVC()
        setupTableView()
        setupBarButton()
        setupRefreshControl()
        getAllItems()
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
    
    //MARK: - Setups
    
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
}

//MARK: - Table Methods

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Default
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell( withIdentifier: MainTableViewCell.identifier, for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
        let model = items[indexPath.section]
        cell.configure(with: model)
        return cell
    }
    
    // Index Title
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return items[section].taskName?.prefix(1).capitalized
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        let alphabet = "abcdefghijklmnopqrstuvwxyz"
        return Array(alphabet.uppercased()).compactMap({ "\($0)" })
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        guard let targetIndex = items.firstIndex(where: { $0.taskName?.prefix(1).capitalized  == title }) else {
            return 0
        }
        return targetIndex
    }
    
    // Selection
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = items[indexPath.row]
        showDetailAllert(item: item)
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let item = items[indexPath.row]
        let config = UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil) { _ in
                
                let downloadAction = UIAction(title: "Show Full", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { [weak self] _ in
                    
                    let vc = DetailViewController(item: item)
                    self?.present(vc, animated: true)
                }
                
                return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
            }
        
        return config
    }
}

//MARK: - Actions

extension MainViewController {
    
    @objc private func didPullToRefresh() {
        tableView.animateTableView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.getAllItems()
        }
    }
    
    @objc private func didTapAddButton() {
        showCreateItemAlert()
    }
    
    private func showCreateItemAlert() {
        let alert = UIAlertController(
            title: "New Task",
            message: "Enter new task",
            preferredStyle: .alert
        )
        
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(
            UIAlertAction(
                title: "Submit",
                style: .default,
                handler: { [weak self] _ in
                    
                    guard let field = alert.textFields?.first,
                          let text = field.text,
                          !text.isEmpty else { return }
                    
                    self?.createItem(name: text)
                }
            )
        )
        
        present(alert, animated: true)
    }
    
    private func showDetailAllert(item: MainItem) {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        sheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { [weak self] _ in
            
            let alert = UIAlertController(
                title: "Edit Your Task",
                message: nil,
                preferredStyle: .alert
            )
            
            alert.addTextField(configurationHandler: nil)
            alert.textFields?.first?.text = item.taskName
            alert.addAction(
                UIAlertAction(
                    title: "Save",
                    style: .cancel,
                    handler: { _ in
                        
                        guard let field = alert.textFields?.first,
                              let newName = field.text,
                              !newName.isEmpty else { return }
                        
                        self?.updateItem(item: item, newName: newName)
                    }
                )
            )
            
            self?.present(alert, animated: true)
        }))
        
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            self?.deleteItem(item: item)
        }))
        
        present(sheet, animated: true)
    }
}

//MARK: - Core Data

extension MainViewController {
    func getAllItems() {
        do {
            items = try context.fetch(MainItem.fetchRequest())
            
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
                self?.tableView.refreshControl?.endRefreshing()
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func createItem(name: String) {
        let newItem = MainItem(context: context)
        newItem.taskName = name
        newItem.createdAt = Date()
        
        do {
            try context.save()
            getAllItems()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func deleteItem(item: MainItem) {
        context.delete(item)
        
        do {
            try context.save()
            getAllItems()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func updateItem(item: MainItem, newName: String) {
        item.taskName = newName
        
        do {
            try context.save()
            getAllItems()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}



