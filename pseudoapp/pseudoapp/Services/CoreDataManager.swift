import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    let container: NSPersistentContainer
    var context: NSManagedObjectContext {
        return container.viewContext
    }
    
    private init() {
        container = NSPersistentContainer(name: "pseudoapp")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Failed to initialize CoreData: \(error)")
            }
        }
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed to save CoreData context: \(error)")
            }
        }
    }
    
    func fetchHabits() -> [Habit] {
        let request: NSFetchRequest<HabitEntity> = NSFetchRequest<HabitEntity>(entityName: "HabitEntity")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \HabitEntity.createdAt, ascending: true)]
        do {
            let entities = try context.fetch(request)
            return entities.map { entity in
                var habit = Habit(
                    id: entity.id?.uuidString ?? UUID().uuidString,
                    emoji: entity.emoji ?? "",
                    title: entity.title ?? "",
                    description: entity.desc ?? "",
                    streak: Int(entity.streak),
                    completedDates: entity.completedDates ?? []
                )
                habit.streak = habit.calculateStreak()
                return habit
            }
        } catch {
            print("Failed to fetch habits: \(error)")
            return []
        }
    }
    
    func addHabit(_ habit: Habit) {
        let entity = HabitEntity(context: context)
        entity.id = UUID(uuidString: habit.id) ?? UUID()
        entity.emoji = habit.emoji
        entity.title = habit.title
        entity.desc = habit.description
        entity.streak = Int64(habit.streak)
        entity.completedDates = habit.completedDates
        entity.createdAt = Date()
        
        saveContext()
    }
    
    func updateHabit(_ habit: Habit) {
        let request: NSFetchRequest<HabitEntity> = NSFetchRequest<HabitEntity>(entityName: "HabitEntity")
        request.predicate = NSPredicate(format: "id == %@", habit.id)
        
        do {
            if let entity = try context.fetch(request).first {
                entity.emoji = habit.emoji
                entity.title = habit.title
                entity.desc = habit.description
                entity.streak = Int64(habit.streak)
                entity.completedDates = habit.completedDates
                saveContext()
            }
        } catch {
            print("Failed to update habit: \(error)")
        }
    }
    
    func deleteHabit(id: String) {
        let request: NSFetchRequest<HabitEntity> = NSFetchRequest<HabitEntity>(entityName: "HabitEntity")
        request.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            if let entity = try context.fetch(request).first {
                context.delete(entity)
                saveContext()
            }
        } catch {
            print("Failed to delete habit: \(error)")
        }
    }
}
