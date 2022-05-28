//
//  MainPresenter.swift
//  ToDoList_MVP_CoreData
//
//  Created by Mikhail Kostylev on 27.05.2022.
//

import Foundation
import UIKit

protocol MainPresenterOutput: AnyObject {
    var items: [MainItem]? { get set }
    init(view: MainPresenterInput)
    func getAllItems()
    func createItem(name: String)
    func deleteItem(item: MainItem)
    func updateItem(item: MainItem, newName: String)
    func showCreateItemAlert()
    func showDetailAllert(item: MainItem)
    func showEditAlert(item: MainItem)
}

final class MainViewPresenter: MainPresenterOutput {
        
    weak var view: MainPresenterInput!
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var items: [MainItem]?
    
    //MARK: - Initializer
    
    required init(view: MainPresenterInput) {
        self.view = view
        getAllItems()
    }
    
    //MARK: - ALerts Logic
    
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
            self?.view.showDetailVC(item: item)
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
    
    //MARK: - Core Data Logic
    
    func getAllItems() {
        do {
            items = try context.fetch(MainItem.fetchRequest())
            
            view.refreshTable()
            
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
