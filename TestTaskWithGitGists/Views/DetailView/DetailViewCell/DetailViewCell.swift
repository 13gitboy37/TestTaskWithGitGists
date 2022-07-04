//
//  DetailViewCell.swift
//  TestTaskWithGitGists
//
//  Created by Никита Мошенцев on 30.06.2022.
//

import UIKit

class DetailViewCell: UICollectionViewCell {
    
    @IBOutlet weak var filename: UILabel!
    @IBOutlet weak var contenFile: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(file: FileGist) {
        filename.text = file.filename
        contenFile.text = file.content
    }
}
