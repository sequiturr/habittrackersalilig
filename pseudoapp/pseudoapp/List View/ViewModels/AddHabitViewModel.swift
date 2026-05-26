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
            let habit = Habit(id: UUID().uuidString, emoji: emoji, title: title, description: desc, streak: 0, completedDates: [])
            
            //save to CoreData
            CoreDataManager.shared.addHabit(habit)
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
                let habit = Habit(id: id, emoji: emoji, title: title, description: desc, streak: 0, completedDates: [])
                
                //update in CoreData
                CoreDataManager.shared.updateHabit(habit)
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

