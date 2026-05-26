//
//  HabitListViewModel.swift
//  HabitTracker-Salilig
//
//  Created by Charle Salilig on 5/22/26.
//

import SwiftUI
import Combine


class HabitListViewModel: ObservableObject {
    @Published var habits: [Habit] = []
    @Published var streak: Int = 0
    @Published var dateString: String = Date().formatted()
    
    init() {
        dateString = updateDate()
        listenToHabits()
    }
    
    func listenToHabits() {
        self.habits = CoreDataManager.shared.fetchHabits()
        self.updateStreakAndDate()
    }
    
    private func updateStreakAndDate() {
        self.dateString = updateDate()
        // Compute overall streak based on CoreData habits
        self.streak = computeOverallStreak()
    }
    
    func refresh() {
        self.habits = CoreDataManager.shared.fetchHabits()
        self.updateStreakAndDate()
    }
    
    private func computeOverallStreak() -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let savedStreak = UserDefaults.standard.integer(forKey: "userOverallStreak")
        let savedLastCompleted = UserDefaults.standard.string(forKey: "userLastCompleted") ?? ""
        let todayStr = formatter.string(from: Date())
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let yesterdayStr = formatter.string(from: yesterday)
        
        let hasCompletedHabitToday = habits.contains(where: { $0.completedDates.contains(todayStr) })
        
        if hasCompletedHabitToday {
            if savedLastCompleted == todayStr {
                return savedStreak
            } else {
                let newStreak = (savedLastCompleted == yesterdayStr) ? (savedStreak + 1) : 1
                UserDefaults.standard.set(newStreak, forKey: "userOverallStreak")
                UserDefaults.standard.set(todayStr, forKey: "userLastCompleted")
                return newStreak
            }
        } else {
            if savedLastCompleted == todayStr {
                let newStreak = max(0, savedStreak - 1)
                UserDefaults.standard.set(newStreak, forKey: "userOverallStreak")
                UserDefaults.standard.set("", forKey: "userLastCompleted")
                return newStreak
            } else {
                if !savedLastCompleted.isEmpty && savedLastCompleted != yesterdayStr {
                    UserDefaults.standard.set(0, forKey: "userOverallStreak")
                    return 0
                }
                return savedStreak
            }
        }
    }
    
    func updateDate() -> String {
        let currentDate = Date()
        
        let Formatter: DateFormatter = DateFormatter()
        Formatter.timeStyle = .none
        Formatter.dateStyle = .long
        
        return Formatter.string(from: currentDate)
    }
    
    var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12:
            return "Good morning."
        case 12..<17:
            return "Good afternoon."
        case 17..<22:
            return "Good evening."
        default:
            return "Good night."
        }
    }
    
    func onAddHabitDismissed() {
        // No manual refresh needed — Firestore listener auto-updates
    }
    
}
