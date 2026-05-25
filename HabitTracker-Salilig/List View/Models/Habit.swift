//
//  Habit.swift
//  HabitTracker-Salilig
//
//  Created by Charle Salilig on 5/22/26.
//

import Foundation

struct Habit: Identifiable {
    let id: String
    var emoji: String
    var title: String
    var description: String
    var streak: Int
    var isCompleted: Bool = false
}
