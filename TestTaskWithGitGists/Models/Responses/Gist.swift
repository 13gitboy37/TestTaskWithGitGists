//
//  Gist.swift
//  TestTaskWithGitGists
//
//  Created by Никита Мошенцев on 28.06.2022.
//

import Foundation

struct Gist {
    let url: String
    let owner: OwnerGist
    let id: String
    let createdAt: String
    let files: [String : FileGist]
}

extension Gist: Codable {
    enum CodingKeys: String, CodingKey {
        case url
        case owner
        case id
        case createdAt = "created_at"
        case files
    }
}

