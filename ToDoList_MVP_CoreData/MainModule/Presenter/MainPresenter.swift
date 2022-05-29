//
//  MainPresenter.swift
//  ToDoList_MVP_CoreData
//
//  Created by Mikhail Kostylev on 27.05.2022.
//

import Foundation
import UIKit

protocol MainPresenterProtocol: AnyObject {
    var items: [MainItem]? { get set }
    init(view: MainViewProtocol, storeService: StoreServiceProtocol, router: RouterProtocol)
    func getAllItems()
    func createItem(name: String)
    func deleteItem(item: MainItem)
    func updateItem(item: MainItem, newName: String)
    func showCreateItemAlert()
    func showDetailAllert(item: MainItem)
    func showEditAlert(item: MainItem)
    func showDetailVC(item: MainItem)
}

final class MainPresenter: MainPresenterProtocol {
    
    weak var view: MainViewProtocol!
    var storeService: StoreServiceProtocol!
    var router: RouterProtocol?
    var items: [MainItem]?
    
    // MARK: - Initializer
    
    required init(view: MainViewProtocol, storeService: StoreServiceProtocol, router: RouterProtocol) {
        self.view = view
        self.storeService = storeService
        self.router = router
        getAllItems()
    }
    
    // MARK: - Navigation
    
    func showDetailVC(item: MainItem) {
        router?.showDetailVC(with: item)
    }
    
    // MARK: - Store Service
    
    func getAllItems() {
        storeService.getAllItems()
        items = storeService.items
        view.refreshTable()
    }
    
    func deleteItem(item: MainItem) {
        storeService.deleteItem(item: item)
        items = storeService.items
        view.refreshTable()
    }
    
    func createItem(name: String) {
        storeService.createItem(name: name)
        items = storeService.items
        view.refreshTable()
    }
    
    func updateItem(item: MainItem, newName: String) {
        storeService.updateItem(item: item, newName: newName)
        items = storeService.items
        view.refreshTable()
    }
    
    // MARK: - ALerts
    
    func showCreateItemAlert() {
        let alert = UIAlertController(
            title: "New Task",
            message: "Enter new task",
            preferredStyle: .alert
        )
        
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(
            UIAlertAction(
                title: "Enter",
                style: .default,
                handler: { [weak self] _ in
                    
                    guard let field = alert.textFields?.first,
                          let text = field.text,
                          !text.isEmpty else { return }
                    
                    self?.createItem(name: text)
                }
            )
        )
        
        view.presentAlert(alert: alert)
    }
    
    func showDetailAllert(item: MainItem) {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        sheet.addAction(UIAlertAction(title: "Show Full", style: .default, handler: { [weak self] _ in
            self?.showDetailVC(item: item)
        }))
        
        sheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { [weak self] _ in
            self?.showEditAlert(item: item)
        }))
        
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            self?.deleteItem(item: item)
        }))
        
        view.presentAlert(alert: sheet)
    }
    
    func showEditAlert(item: MainItem) {
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
                handler: { [weak self] _ in
                    
                    guard let field = alert.textFields?.first,
                          let newName = field.text,
                          !newName.isEmpty else { return }
                    
                    self?.updateItem(item: item, newName: newName)
                }
            )
        )
        
        view.presentAlert(alert: alert)
    }
}
