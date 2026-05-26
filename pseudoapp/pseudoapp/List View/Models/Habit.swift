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
    var completedDates: [String] = []
    
    var isCompleted: Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todayStr = formatter.string(from: Date())
        return completedDates.contains(todayStr)
    }
    
    func calculateStreak() -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        var currentStreak = 0
        var currentDate = Date()
        
        // Check today
        let todayStr = formatter.string(from: currentDate)
        if completedDates.contains(todayStr) {
            currentStreak += 1
            currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate)!
        } else {
            // Check if missed yesterday
            let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: currentDate)!
            let yesterdayStr = formatter.string(from: yesterday)
            if !completedDates.contains(yesterdayStr) {
                return 0
            }
            currentDate = yesterday
        }
        
        // Count backwards
        while true {
            let dateStr = formatter.string(from: currentDate)
            if completedDates.contains(dateStr) {
                currentStreak += 1
                currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate)!
            } else {
                break
            }
        }
        
        return currentStreak
    }
}
