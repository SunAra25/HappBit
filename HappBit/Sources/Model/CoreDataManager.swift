//
//  CoreDataManager.swift
//  HappBit
//
//  Created by 아라 on 10/5/24.
//

import Foundation
import CoreData

struct CoreDataManager {
    static let shared = CoreDataManager()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Happbit")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    func saveContext() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension CoreDataManager {
    func fetchHabit() -> [HabitEntity] {
        let request = NSFetchRequest<HabitEntity>(entityName: "Happbit")
        request.relationshipKeyPathsForPrefetching = ["practiceRecords"]
        
        do {
            let list = try container.viewContext.fetch(request)
            return list
        } catch {
            print("ERROR FETCHING CORE DATA")
            print(error.localizedDescription)
            return []
        }
    }
    
    func addHabit(_ data: _Habit) {
        let habit = HabitEntity(context: container.viewContext)
        habit.title = data.title
        habit.colorIndex = data.colorIndex
        habit.createdAt = Date()
        habit.endDate = nil
        saveContext()
    }
    
    func deleteHabit(_ entity: HabitEntity) {
        container.viewContext.delete(entity)
        saveContext()
    }
    
    func pauseHabit(_ entity: HabitEntity) {
        entity.isPause = true
        saveContext()
    }
    
    func restartHabit(_ entity: HabitEntity) {
        entity.isPause = false
        saveContext()
    }
    
    func addRecord(_ entity: HabitEntity) {
        let record = RecordEntity(context: container.viewContext)
        record.date = Date()
        record.habitInfo = entity
        entity.addToPracticeRecords(record)
        saveContext()
    }
    
    func completeHabit(_ entity: HabitEntity) {
        entity.endDate = Date()
        saveContext()
    }
}
