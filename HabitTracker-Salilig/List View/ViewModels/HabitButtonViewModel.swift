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
        habit.isCompleted.toggle()
        
        if habit.isCompleted {
            habit.streak += 1
        } else {
            habit.streak -= 1
        }
        
        // Save updated state to Firestore
        FirestoreService.shared.updateHabit(habit) { success in
            if !success {
                print("Failed to update habit completion")
            }
        }
    }
    
    func deleteHabit() {
        FirestoreService.shared.deleteHabit(id: habit.id) { [weak self] success in
            if success {
                self?.isDeleted = true
                self?.buttonOpacity = 0.3
            }
        }
    }
}
