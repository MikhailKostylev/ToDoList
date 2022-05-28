//
//  MainTableViewCell.swift
//  ToDoList_MVP_CoreData
//
//  Created by Mikhail Kostylev on 27.05.2022.
//

import UIKit

final class MainTableViewCell: UITableViewCell {
    
    static let identifier = "MainTableViewCell"
    
    //MARK: - UI elements
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .tertiaryLabel
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let padding: CGFloat = 10
    
    //MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupCellLayout()
    }
    
    //MARK: - Setups
    
    private func setupCellLayout() {
        contentView.layer.cornerRadius = 10
        contentView.frame = contentView.frame.inset(
            by: UIEdgeInsets(
                top: padding,
                left: padding,
                bottom: padding,
                right: padding
            )
        )
    }
    
    private func setupCell() {
        selectionStyle = .none
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(nameLabel)
        contentView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            nameLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.75),

            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    //MARK: - Configure
    
    func configure(with model: MainItem) {
        nameLabel.text = model.taskName
        dateLabel.text = "Created at: \(model.createdAt?.toString() ?? "")"
    }
}
