// JournalEntry.swift - SwiftData model representing a single journal entry.
//  JournalEntry.swift
//  Project_108-2
//
//  Model: Represents a single journal entry persisted with SwiftData.
//  Created by Saul Herrera on 2/16/26.
//

import Foundation
import SwiftData

@Model
final class JournalEntry {
    var title: String
    var body: String
    var date: Date
    var isFavorite: Bool
    var category: String = "Personal"
    var isArchived: Bool = false

    init(title: String, body: String, date: Date = .now, isFavorite: Bool = false, category: String = "Personal", isArchived: Bool = false) {
        self.title = title
        self.body = body
        self.date = date
        self.isFavorite = isFavorite
        self.category = category
        self.isArchived = isArchived
    }
}
