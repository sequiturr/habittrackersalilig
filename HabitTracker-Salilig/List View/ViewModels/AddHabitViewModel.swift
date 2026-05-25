//
//  AddHabitViewModel.swift
//  HabitTracker-Salilig
//
//  Created by Charle Salilig on 5/22/26.
//

import Foundation
import Combine

class AddHabitViewModel: ObservableObject {
    @Published var emoji: String = "📖"
    @Published var title: String = ""
    @Published var desc: String = ""
    @Published var isError: String = ""
    
    var editingHabitId: String?
    
    
    func addHabit() -> Bool {
        //validation
        if (validate()) {
            let habit = Habit(id: UUID().uuidString, emoji: emoji, title: title, description: desc, streak: 0)
            
            //save to Firestore (fire-and-forget, syncs in background)
            FirestoreService.shared.addHabit(habit) { success in
                if !success {
                    print("Failed to save habit to Firestore")
                }
            }
            erase()
            return true
        } else {
            isError = "Please fill all the fields"
            return false
        }
    }
    
    func updateHabit() -> Bool {
        if (validate()) {
            if let id = editingHabitId {
                let habit = Habit(id: id, emoji: emoji, title: title, description: desc, streak: 0)
                
                //update in Firestore (fire-and-forget)
                FirestoreService.shared.updateHabit(habit) { success in
                    if !success {
                        print("Failed to update habit in Firestore")
                    }
                }
                erase()
                return true
            }
        } else {
            isError = "Please fill all the fields"
            return false
        }
        return false
    }
    
    func validate() -> Bool {
        return emoji.count > 0 && title.count > 1 && desc.count > 1
    }
    
    //erase
    func erase() {
        emoji = "📖"
        title = ""
        desc = ""
    }
}

