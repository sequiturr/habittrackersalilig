//
//  HabitListViewModel.swift
//  HabitTracker-Salilig
//
//  Created by Charle Salilig on 5/22/26.
//

import SwiftUI
import Combine
import FirebaseFirestore

class HabitListViewModel: ObservableObject {
    @Published var habits: [Habit] = []
    @Published var streak: Int = 0
    @Published var dateString: String = Date().formatted()
    
    private var listener: ListenerRegistration?
    private var streakListener: ListenerRegistration?
    
    init() {
        dateString = updateDate()
        startListening()
    }
    
    deinit {
        listener?.remove()
        streakListener?.remove()
    }
    
    func startListening() {
        listener = FirestoreService.shared.listenToHabits { [weak self] habits in
            DispatchQueue.main.async {
                self?.habits = habits
            }
        }
        
        streakListener = FirestoreService.shared.listenToStreak { [weak self] streak in
            DispatchQueue.main.async {
                self?.streak = streak
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
    
    func refresh() {
        // No manual refresh needed — Firestore listener auto-updates
    }
}
