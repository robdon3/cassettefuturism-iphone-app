//
//  Item.swift
//  Atrium
//
//  Created by Robert Donohue on 6/24/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    var title: String
    var details: String
    var category: String
    
    init(timestamp: Date, title: String = "", details: String = "", category: String = "general") {
        self.timestamp = timestamp
        self.title = title
        self.details = details
        self.category = category
    }
}

@Model
final class CassetteMemory {
    var id: UUID
    var title: String
    var content: String
    var createdAt: Date
    var category: String // "conan", "wargames", "galaga", "yuppie", etc.
    var isFavorite: Bool
    
    init(title: String, content: String, category: String = "general") {
        self.id = UUID()
        self.title = title
        self.content = content
        self.createdAt = Date()
        self.category = category
        self.isFavorite = false
    }
}

@Model
final class RetroGame {
    var id: UUID
    var name: String
    var highScore: Int
    var lastPlayed: Date
    var gameType: String // "galaga", "space_invaders", "tetris", etc.
    
    init(name: String, gameType: String) {
        self.id = UUID()
        self.name = name
        self.highScore = 0
        self.lastPlayed = Date()
        self.gameType = gameType
    }
}
