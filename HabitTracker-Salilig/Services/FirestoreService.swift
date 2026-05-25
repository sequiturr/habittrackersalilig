//
//  FirestoreService.swift
//  HabitTracker-Salilig
//
//  Created by Charle Salilig on 5/25/26.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class FirestoreService {
    static let shared = FirestoreService()
    private let db = Firestore.firestore()
    
    private var habitsCollection: CollectionReference? {
        guard let uid = Auth.auth().currentUser?.uid else { return nil }
        return db.collection("users").document(uid).collection("habits")
    }
    
    // MARK: - Add a new habit
    func addHabit(_ habit: Habit, completion: @escaping (Bool) -> Void) {
        guard let habitsColl = habitsCollection else {
            completion(false)
            return
        }
        
        let data: [String: Any] = [
            "id": habit.id,
            "emoji": habit.emoji,
            "title": habit.title,
            "description": habit.description,
            "streak": habit.streak,
            "isCompleted": habit.isCompleted,
            "createdAt": Timestamp(date: Date())
        ]
        
        habitsColl.document(habit.id).setData(data) { [weak self] error in
            if let error = error {
                print("Error adding habit: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Habit added successfully")
                self?.checkAndUpdateStreak()
                completion(true)
            }
        }
    }
    
    // MARK: - Update an existing habit
    func updateHabit(_ habit: Habit, completion: @escaping (Bool) -> Void) {
        guard let habitsColl = habitsCollection else {
            completion(false)
            return
        }
        
        let data: [String: Any] = [
            "emoji": habit.emoji,
            "title": habit.title,
            "description": habit.description,
            "streak": habit.streak,
            "isCompleted": habit.isCompleted
        ]
        
        habitsColl.document(habit.id).updateData(data) { [weak self] error in
            if let error = error {
                print("Error updating habit: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Habit updated successfully")
                self?.checkAndUpdateStreak()
                completion(true)
            }
        }
    }
    
    // MARK: - Delete a habit
    func deleteHabit(id: String, completion: @escaping (Bool) -> Void) {
        guard let habitsColl = habitsCollection else {
            completion(false)
            return
        }
        
        habitsColl.document(id).delete { [weak self] error in
            if let error = error {
                print("Error deleting habit: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Habit deleted successfully")
                self?.checkAndUpdateStreak()
                completion(true)
            }
        }
    }
    
    // MARK: - Listen to habits in real-time
    func listenToHabits(completion: @escaping ([Habit]) -> Void) -> ListenerRegistration? {
        guard let habitsColl = habitsCollection else {
            completion([])
            return nil
        }
        
        return habitsColl
            .order(by: "createdAt")
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error listening to habits: \(error.localizedDescription)")
                    completion([])
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    completion([])
                    return
                }
                
                let habits = documents.compactMap { doc -> Habit? in
                    let data = doc.data()
                    guard let id = data["id"] as? String,
                          let emoji = data["emoji"] as? String,
                          let title = data["title"] as? String,
                          let description = data["description"] as? String,
                          let streak = data["streak"] as? Int,
                          let isCompleted = data["isCompleted"] as? Bool
                    else { return nil }
                    
                    return Habit(
                        id: id,
                        emoji: emoji,
                        title: title,
                        description: description,
                        streak: streak,
                        isCompleted: isCompleted
                    )
                }
                
                completion(habits)
            }
    }
    
    // MARK: - Listen to user streak in real-time
    func listenToStreak(completion: @escaping (Int) -> Void) -> ListenerRegistration? {
        guard let uid = Auth.auth().currentUser?.uid else { return nil }
        
        // Check/reset the streak when we first start listening
        checkAndUpdateStreak()
        
        return db.collection("users").document(uid).addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot, document.exists, let data = document.data() else {
                completion(0)
                return
            }
            let streak = data["streak"] as? Int ?? 0
            completion(streak)
        }
    }
    
    // MARK: - Check and Update Streak
    func checkAndUpdateStreak(completion: @escaping (Int) -> Void = { _ in }) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let habitsColl = habitsCollection else { return }
        
        let userDocRef = db.collection("users").document(uid)
        
        habitsColl.whereField("isCompleted", isEqualTo: true).getDocuments { snapshot, error in
            let hasCompletedHabitToday = !(snapshot?.documents.isEmpty ?? true)
            
            userDocRef.getDocument { docSnapshot, docError in
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                let todayStr = formatter.string(from: Date())
                
                var currentStreak = 0
                var lastCompleted = ""
                
                if let doc = docSnapshot, doc.exists, let data = doc.data() {
                    currentStreak = data["streak"] as? Int ?? 0
                    lastCompleted = data["lastCompletedDate"] as? String ?? ""
                }
                
                if hasCompletedHabitToday {
                    if lastCompleted == todayStr {
                        completion(currentStreak)
                    } else {
                        // Check if yesterday was completed to keep the streak going
                        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
                        let yesterdayStr = formatter.string(from: yesterday)
                        
                        let newStreak = (lastCompleted == yesterdayStr) ? (currentStreak + 1) : 1
                        userDocRef.setData([
                            "streak": newStreak,
                            "lastCompletedDate": todayStr
                        ], merge: true)
                        completion(newStreak)
                    }
                } else {
                    // No habits are completed today
                    if lastCompleted == todayStr {
                        // They unchecked their last completed habit for today
                        let newStreak = max(0, currentStreak - 1)
                        userDocRef.setData([
                            "streak": newStreak,
                            "lastCompletedDate": ""
                        ], merge: true)
                        completion(newStreak)
                    } else {
                        // They haven't completed any habit today.
                        // Check if they missed yesterday as well, if so reset streak to 0.
                        if !lastCompleted.isEmpty {
                            let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
                            let yesterdayStr = formatter.string(from: yesterday)
                            if lastCompleted != yesterdayStr {
                                userDocRef.setData([
                                    "streak": 0
                                ], merge: true)
                                completion(0)
                                return
                            }
                        }
                        completion(currentStreak)
                    }
                }
            }
        }
    }
}
