//
//  MainCell.swift
//  TestTaskWithGitGists
//
//  Created by Никита Мошенцев on 28.06.2022.
//

import UIKit

final class MainCell: UITableViewCell {
    
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
        
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureUI()
    }
    
    // MARK: - Methods
    
    func configure(with cellModel: Gist, avatar: UIImage) {
        self.nameGistLabel.text = cellModel.id
        self.userNameLabel.text = cellModel.owner.login
        self.avatarImage.image = avatar
    }
    
    // MARK: - UI
    
    override func prepareForReuse() {
        [self.nameGistLabel, self.userNameLabel].forEach { $0.text = nil }
    }
    
    private func configureUI() {
        
        self.addAvatarImage()
        self.addNameGistLabel()
        self.addUserNameLabel()
    }
    
    private func addNameGistLabel() {
        self.contentView.addSubview(self.nameGistLabel)
        NSLayoutConstraint.activate([
            self.nameGistLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8.0),
            self.nameGistLabel.leftAnchor.constraint(equalTo: self.avatarImage.rightAnchor, constant: 10.0),
            self.nameGistLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -40.0)
            ])
    }

    private func addUserNameLabel() {
        self.contentView.addSubview(self.userNameLabel)
        NSLayoutConstraint.activate([
            self.userNameLabel.topAnchor.constraint(equalTo: self.nameGistLabel.bottomAnchor, constant: 4.0),
            self.userNameLabel.leftAnchor.constraint(equalTo: self.avatarImage.rightAnchor, constant: 10.0),
            self.userNameLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -40.0)
            ])
    }
    
    private func addAvatarImage() {
        self.contentView.addSubview(self.avatarImage)
        NSLayoutConstraint.activate([
            self.avatarImage.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10.0),
            self.avatarImage.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 10.0),
            self.avatarImage.widthAnchor.constraint(equalToConstant: 40),
            self.avatarImage.heightAnchor.constraint(equalToConstant: 40)
            ])
    }

}
