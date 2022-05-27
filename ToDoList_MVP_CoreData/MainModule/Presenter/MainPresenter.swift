//
//  MainPresenter.swift
//  ToDoList_MVP_CoreData
//
//  Created by Mikhail Kostylev on 27.05.2022.
//

import Foundation

protocol MainPresenterOutput: AnyObject {
    // Presenter
}

protocol MainPresenterInput: AnyObject {
    // View
}

class MainViewPresenter: MainPresenterOutput {
    
    weak var view: MainPresenterInput!
}
