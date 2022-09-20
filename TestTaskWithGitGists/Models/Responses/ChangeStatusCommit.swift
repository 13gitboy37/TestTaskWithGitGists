//
//  ChangeStatusCommit.swift
//  TestTaskWithGitGists
//
//  Created by Никита Мошенцев on 01.07.2022.
//

import Foundation

struct ChangeStatusCommit {
    let additions: Int
    let deletions: Int
}

extension ChangeStatusCommit: Codable {
    enum CodingKeys: String, CodingKey {
        case additions
        case deletions
    }
}
