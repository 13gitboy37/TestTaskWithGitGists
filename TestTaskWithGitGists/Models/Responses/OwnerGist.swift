//
//  OwnerGist.swift
//  TestTaskWithGitGists
//
//  Created by Никита Мошенцев on 28.06.2022.
//

import Foundation


struct OwnerGist {
    let login: String
    let avatarUrl: String
}

extension OwnerGist: Codable {
    enum CodingKeys: String, CodingKey {
        case login = "login"
        case avatarUrl = "avatar_url"
    }
}
