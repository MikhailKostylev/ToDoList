//
//  DetailController.swift
//  ToDoList_MVP_CoreData
//
//  Created by Mikhail Kostylev on 27.05.2022.
//

import UIKit

class DetailViewController: UIViewController, DetailPresenterInput {
    
    var output: DetailPresenterOutput!
    
    var item: MainItem?
    
    //MARK: - UI elements
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .medium)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .regular)
        return label
    }()
    
    //MARK: - Initializers
    
    init(item: MainItem) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupVC()
        setupLabels()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        nameLabel.center = view.center
        nameLabel.frame = CGRect(
            x: 0,
            y: 0,
            width: view.width,
            height: view.width
        )
        
        dateLabel.center = view.center
        dateLabel.frame = CGRect(
            x: 0,
            y: nameLabel.bottom,
            width: view.width,
            height: view.width
        )
    }
    
    //MARK: - Setups
    
    private func setupVC() {
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func setupLabels() {
        view.addSubview(nameLabel)
        view.addSubview(dateLabel)
        
        nameLabel.text = item?.taskName
        dateLabel.text = item?.createdAt?.toString()
    }
}
