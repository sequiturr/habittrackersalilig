//
//  HabitButtonViewModel.swift
//  HabitTracker-Salilig
//
//  Created by Charle Salilig on 5/22/26.
//

import Foundation
import Combine

class HabitButtonViewModel: ObservableObject{
    @Published var habit: Habit
    @Published var isDeleted: Bool = false
    @Published var buttonOpacity: Double = 1.0
    
    init(habit: Habit) {
        self.habit = habit
    }
    
    func buttonHabitTapped() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todayStr = formatter.string(from: Date())
        
        if habit.completedDates.contains(todayStr) {
            habit.completedDates.removeAll { $0 == todayStr }
        } else {
            habit.completedDates.append(todayStr)
        }
        
        habit.streak = habit.calculateStreak()
        
        // Save updated state to CoreData
        CoreDataManager.shared.updateHabit(habit)
    }
    
    func deleteHabit() {
        CoreDataManager.shared.deleteHabit(id: habit.id)
        self.isDeleted = true
        self.buttonOpacity = 0.3
    }
}
