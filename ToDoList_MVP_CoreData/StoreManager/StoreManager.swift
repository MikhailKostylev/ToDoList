//
//  StoreManager.swift
//  ToDoList_MVP_CoreData
//
//  Created by Mikhail Kostylev on 29.05.2022.
//

import UIKit

protocol StoreManagerProtocol: AnyObject {
    func getAllItems()
    func createItem(name: String)
    func deleteItem(item: MainItem)
    func updateItem(item: MainItem, newName: String)
    var items: [MainItem]? { get set }
}

class StoreManager: StoreManagerProtocol {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var items: [MainItem]?
    
    func getAllItems() {
        do {
            items = try context.fetch(MainItem.fetchRequest())
        } catch let error {
            print(error)
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
