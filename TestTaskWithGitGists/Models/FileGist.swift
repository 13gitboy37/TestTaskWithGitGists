//
//  FileGist.swift
//  TestTaskWithGitGists
//
//  Created by Никита Мошенцев on 30.06.2022.
//

import Foundation

struct FileGist {
    let filename: String
    let type: String
    let content: String?
}

extension FileGist: Codable {
    enum CodingKeys: String, CodingKey {
        case filename
        case type
        case content
}
}
