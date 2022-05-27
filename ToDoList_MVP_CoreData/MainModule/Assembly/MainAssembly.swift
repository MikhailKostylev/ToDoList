//
//  MainAssembly.swift
//  ToDoList_MVP_CoreData
//
//  Created by Mikhail Kostylev on 27.05.2022.
//

import Foundation
import UIKit

class MainAssembly {
    
    class func configureModule() -> UIViewController {
        let view = MainViewController()
        let presenter = MainViewPresenter()
        view.output = presenter
        presenter.view = view
        return view
    }
}
