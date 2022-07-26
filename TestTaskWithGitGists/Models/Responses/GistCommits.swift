//
//  GistCommits.swift
//  TestTaskWithGitGists
//
//  Created by Никита Мошенцев on 30.06.2022.
//

import Foundation

struct GistCommits {
    let version: String
    let changeStatus: ChangeStatusCommit
}

extension GistCommits: Codable {
    enum CodingKeys: String, CodingKey {
        case version
        case changeStatus = "change_status"
    }
}
