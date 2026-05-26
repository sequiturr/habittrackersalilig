//
//  DeveloperPreview.swift
//  HabitTracker-Salilig
//
//  Created by Charle Salilig on 5/22/26.
//

import Foundation

class DeveloperPreview {
    //habits static value
    static var habits: [Habit] = [
        .init(
            id: NSUUID().uuidString,
            emoji: "🏋️‍♂️",
             title: "Exercise",
             description: "Something, something",
             streak: 0
        ),
        .init(id: NSUUID().uuidString, emoji: "🧘", title: "Meditation", description: "Calmness", streak: 2),
        .init(id: NSUUID().uuidString, emoji: "📖", title: "Reading", description: "Read a book", streak: 1)
        
]
}

