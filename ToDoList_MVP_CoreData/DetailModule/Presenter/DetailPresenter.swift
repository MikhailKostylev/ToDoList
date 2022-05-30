//
//  DetailPresenter.swift
//  ToDoList_MVP_CoreData
//
//  Created by Mikhail Kostylev on 29.05.2022.
//

import Foundation

protocol DetailPresenterProtocol: AnyObject {
    init(view: DetailViewProtocol, item: MainItem, router: RouterProtocol)
    func configureLabels()
    func backToRootVC()
}

final class DetailViewPresenter: DetailPresenterProtocol {
    
    weak var view: DetailViewProtocol?
    var router: RouterProtocol?
    var item: MainItem?
    
    required init(view: DetailViewProtocol, item: MainItem, router: RouterProtocol) {
        self.view = view
        self.router = router
        self.item = item
    }
    
    public func configureLabels() {
        guard let item = item else { return }
        view?.configure(with: item)
    }
    
    func backToRootVC() {
        router?.popToRoot()
    }
}
