//
//  DetailAssembly.swift
//  ToDoList_MVP_CoreData
//
//  Created by Mikhail Kostylev on 27.05.2022.
//

import Foundation
import UIKit

class DetailAssembly {
    
    class func configureModule() -> UIViewController {
        let view = DetailViewController(item: MainItem()) //fix
        let presenter = DetailViewPresenter()
        view.output = presenter
        presenter.view = view
        return view
    }
}
