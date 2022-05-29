//
//  DetailPresenter.swift
//  ToDoList_MVP_CoreData
//
//  Created by Mikhail Kostylev on 29.05.2022.
//

import Foundation

protocol DetailPresenterProtocol: AnyObject {
    init(view: DetailViewProtocol, item: MainItem, router: RouterProtocol)
    func setupLabels(with item: MainItem)
    func backToRootVC()
}

final class DetailViewPresenter: DetailPresenterProtocol {
    
    weak var view: DetailViewProtocol!
    var router: RouterProtocol?
    
    required init(view: DetailViewProtocol, item: MainItem, router: RouterProtocol) {
        self.view = view
        self.router = router
        setupLabels(with: item)
    }
    
    public func setupLabels(with item: MainItem) {
        view.configure(with: item)
    }
    
    func backToRootVC() {
        router?.popToRoot()
    }
}
