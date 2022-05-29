//
//  MainItem+CoreDataProperties.swift
//  ToDoList_MVP_CoreData
//
//  Created by Mikhail Kostylev on 27.05.2022.
//
//

import Foundation
import CoreData

extension MainItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MainItem> {
        return NSFetchRequest<MainItem>(entityName: "MainItem")
    }

    @NSManaged public var taskName: String?
    @NSManaged public var createdAt: Date?

}

extension MainItem: Identifiable {

}
