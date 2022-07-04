//
//  CommitsFileCell.swift
//  TestTaskWithGitGists
//
//  Created by Никита Мошенцев on 01.07.2022.
//

import UIKit

class CommitsFileCell: UICollectionViewCell {
    
    @IBOutlet weak var commitNameLabel: UILabel!
    @IBOutlet weak var additingLabel: UILabel!
    @IBOutlet weak var deletionsLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(gistCommits: GistCommits) {
        self.commitNameLabel.text = gistCommits.version
        self.additingLabel.text = "Additions: \(gistCommits.changeStatus.additions)"
        self.deletionsLabel.text = "Deletions: \(gistCommits.changeStatus.deletions)"
    }
}
