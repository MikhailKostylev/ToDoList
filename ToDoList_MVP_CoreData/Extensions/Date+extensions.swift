//
//  Date+extensions.swift
//  ToDoList_MVP_CoreData
//
//  Created by Mikhail Kostylev on 27.05.2022.
//

import Foundation

extension Date {

    func toString(format: String = "dd-MM-yyyy HH:mm") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
