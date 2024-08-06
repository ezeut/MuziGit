//
//  Contribution.swift
//  MuziGit
//
//  Created by 이지은 on 8/7/24.
//

import Foundation

struct Contribution {
    enum Level: Int, CaseIterable {
        case zero, one, two, three, four
    }
    
    let date: Date
    let count: Int
    let level: Level
    
    init(date: Date, count: Int, level: Level) {
        self.date = date
        self.count = count
        self.level = level
    }
}

extension Contribution.Level {
    static func random() {
        Self.allCases.randomElement()!
    }
}
