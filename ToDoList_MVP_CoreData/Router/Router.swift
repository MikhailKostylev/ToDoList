//
//  Router.swift
//  ToDoList_MVP_CoreData
//
//  Created by Mikhail Kostylev on 29.05.2022.
//

import UIKit

protocol HeadRouter {
    var navigationController: UINavigationController? { get set }
    var assembly: AssemblyProtocol? { get set }
}

protocol RouterProtocol: HeadRouter {
    func initialViewController()
    func showDetailVC(with item: MainItem)
    func popToRoot()
}

final class Router: RouterProtocol {
    
    var navigationController: UINavigationController?
    var assembly: AssemblyProtocol?
    
    init(navigationController: UINavigationController, assembly: AssemblyProtocol) {
        self.navigationController = navigationController
        self.assembly = assembly
    }
    
    func initialViewController() {
        if let navigationController = navigationController {
            guard let mainVC = assembly?.configureMainModule(router: self) else { return }
            navigationController.viewControllers = [mainVC]
        }
    }
    
    func showDetailVC(with item: MainItem) {
        if let navigationController = navigationController {
            guard let detailVC = assembly?.configureDetailModule(item: item, router: self) else { return }
            navigationController.pushViewController(detailVC, animated: true )
        }
    }
    
    func popToRoot() {
        if let navigationController = navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
}
