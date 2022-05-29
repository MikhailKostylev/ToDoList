//
//  Assembly.swift
//  ToDoList_MVP_CoreData
//
//  Created by Mikhail Kostylev on 27.05.2022.
//

import Foundation
import UIKit

protocol AssemblyProtocol {
    func configureMainModule(router: RouterProtocol) -> UIViewController
    func configureDetailModule(item: MainItem, router: RouterProtocol) -> UIViewController
}

final class Assembly: AssemblyProtocol {
    
    func configureMainModule(router: RouterProtocol) -> UIViewController {
        let storeService = StoreService()
        let view = MainViewController()
        let presenter = MainPresenter(view: view, storeService: storeService, router: router)
        view.presenter = presenter
        presenter.view = view
        return view
    }
    
    func configureDetailModule(item: MainItem, router: RouterProtocol) -> UIViewController {
        let view = DetailViewController()
        let presenter = DetailViewPresenter(view: view, item: item, router: router)
        view.presenter = presenter
        presenter.view = view
        return view
    }
}
