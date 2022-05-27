//
//  MainTableViewCell.swift
//  ToDoList_MVP_CoreData
//
//  Created by Mikhail Kostylev on 27.05.2022.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    static let identifier = "MainTableViewCell"
    
    //MARK: - UI elements
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: .regular)
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .tertiaryLabel
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    //MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(nameLabel)
        contentView.addSubview(dateLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let padding: CGFloat = 10
        contentView.layer.cornerRadius = 10
        contentView.frame = contentView.frame.inset(
            by: UIEdgeInsets(
                top: padding,
                left: padding,
                bottom: padding,
                right: padding
            )
        )
        
        nameLabel.frame = CGRect(
            x: padding,
            y: 0,
            width: contentView.width-(padding*2),
            height: contentView.height/1.4
        )
        
        dateLabel.frame = CGRect(
            x: padding,
            y: nameLabel.bottom,
            width: contentView.width-(padding*2),
            height: contentView.height/4
        )
    }
    
    //MARK: - Configure
    
    func configure(with model: MainItem) {
        nameLabel.text = model.taskName
        dateLabel.text = "Created at: \(model.createdAt?.toString() ?? "")"
    }

}
