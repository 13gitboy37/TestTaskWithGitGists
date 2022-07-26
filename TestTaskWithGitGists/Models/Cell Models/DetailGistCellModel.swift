//
//  DetailGistModel.swift
//  TestTaskWithGitGists
//
//  Created by Никита Мошенцев on 30.06.2022.
//

import Foundation

//Cell Model - модель подготовленная для ячейки

struct DetailGistCellModel {
    let userName: String
    let avatarURL: String
    let files: [FileGist]
}
