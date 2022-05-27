//
//  DetailPresenter.swift
//  ToDoList_MVP_CoreData
//
//  Created by Mikhail Kostylev on 27.05.2022.
//

import Foundation

protocol DetailPresenterOutput: AnyObject {
    // Presenter
}

protocol DetailPresenterInput: AnyObject {
    // View
}

class DetailViewPresenter: DetailPresenterOutput {
    
    weak var view: DetailPresenterInput!
}