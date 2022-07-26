//
//  MainCell.swift
//  TestTaskWithGitGists
//
//  Created by Никита Мошенцев on 28.06.2022.
//

import UIKit

final class MainCell: UITableViewCell {
    
    static let reuseIdentifier = "reuseId"
    
    private(set) lazy var nameGistLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14.0)
        return label
    }()
    
    private(set) lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 11.0)
        return label
    }()
    
    private(set) lazy var avatarImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "person.fill")
        return imageView
    }()
    
    // MARK: - Lifecycle
    
    override func prepareForReuse() {
        [self.nameGistLabel, self.userNameLabel].forEach { $0.text = nil }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
        setupConstraints()
    }
    
    // MARK: - Methods
    
    #warning("Всегда прокидываем данные через configure - 1 модель cellModel")
    func configure(with cellModel: MainCellModel, avatar: UIImage) {
        self.nameGistLabel.text = cellModel.fileName
        self.userNameLabel.text = cellModel.userName
        self.avatarImage.image = avatar
    }
    
    private func setupViews() {
        contentView.addSubview(nameGistLabel)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(avatarImage)
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            nameGistLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8.0),
            nameGistLabel.leftAnchor.constraint(equalTo: self.avatarImage.rightAnchor, constant: 10.0),
            nameGistLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -40.0)
        ])
        
        NSLayoutConstraint.activate([
            self.userNameLabel.topAnchor.constraint(equalTo: self.nameGistLabel.bottomAnchor, constant: 4.0),
            self.userNameLabel.leftAnchor.constraint(equalTo: self.avatarImage.rightAnchor, constant: 10.0),
            self.userNameLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -40.0)
        ])
        
        NSLayoutConstraint.activate([
            self.avatarImage.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10.0),
            self.avatarImage.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 10.0),
            self.avatarImage.widthAnchor.constraint(equalToConstant: 40),
            self.avatarImage.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    
}
