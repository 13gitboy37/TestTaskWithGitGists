//
//  DateFormatter.swift
//  TestTaskWithGitGists
//
//  Created by Никита Мошенцев on 25.07.2022.
//

import Foundation

final class DateFormatte {
    
    var lastDate = ""
    
    func dateFormmater(lastDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        var date = dateFormatter.date(from: lastDate)!
        date.addTimeInterval(-60 * 60 * 24)
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
}
