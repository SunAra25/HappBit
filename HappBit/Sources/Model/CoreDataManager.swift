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
    private let calendar = Calendar.current
    
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
        let request = NSFetchRequest<HabitEntity>(entityName: "Habit")
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
    
    func fetchHabit(id: NSManagedObjectID) -> HabitEntity? {
        let request = NSFetchRequest<HabitEntity>(entityName: "Habit")
        request.relationshipKeyPathsForPrefetching = ["practiceRecords"]
        
        do {
            let item = try container.viewContext.existingObject(with: id) as? HabitEntity
            return item
        } catch {
            print("ERROR FETCHING CORE DATA")
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    func addHabit(_ data: Habit) {
        let habit = HabitEntity(context: container.viewContext)
        habit.title = data.title
        habit.colorIndex = data.colorIndex
        habit.createdAt = Date()
        habit.endDate = nil
        saveContext()
    }
    
    func updateHabit(_ entity: HabitEntity, newTitle: String, newColorIndex: Int?) {
        entity.title = newTitle
        if let newColorIndex {
            entity.colorIndex = Int16(newColorIndex)
        }
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
    
    func cancelRecord(_ entity: HabitEntity) {
        guard let records = entity.practiceRecords as? Set<RecordEntity> else { return }
        
        let record = records.filter { record in
            guard let date = record.date else { return false }
            return calendar.isDateInToday(date)
        }
        
        guard let target = record.first else { return }
        
        container.viewContext.delete(target)
        saveContext()
    }
    
    func completeHabit(_ entity: HabitEntity) {
        entity.endDate = Date()
        saveContext()
    }
}

extension CoreDataManager {
    func calculateConsecutiveDays(_ array: [Date]) -> Int {
        if array.isEmpty { return 0 }
        
        var count = 0
        let diff = lastRecordDiff(array[0])
        
        if diff > 1 { return 0 }
        
        for i in 0..<array.count - 1 {
            let target = array[i + 1]
            let current = array[i]
            let currentDay = calendar.date(byAdding: .day, value: -1, to: current) ?? Date()
            let isSameDay = calendar.isDate(currentDay, inSameDayAs: target)
            
            if !isSameDay {
                break
            }
            
            count += 1
        }
        
        count += diff == 0 ? 1 : 0
        
        return count
    }
    
    func calculateCloverCount(_ array: [Date]) -> Int {
        var currentCount = 1
        var cloverCount = 0
        
        if array.count < 3 {
            return 0
        }
        
        var array = array
        array.sort { $0 > $1 }
        
        for i in 1..<array.count {
            let target = array[i - 1]
            let current = array[i]
            let currentDay = calendar.date(byAdding: .day, value: 1, to: current) ?? Date()
            let isSameDay = calendar.isDate(currentDay, inSameDayAs: target)
            
            
            if !isSameDay {
                cloverCount += currentCount / 3
                currentCount = 1
            } else {
                currentCount += 1
            }
        }
        
        return cloverCount + (currentCount / 3)
    }
    
    private func calculateRecordDiff(base: Date, target: Date) -> Int {
        guard let diff = calendar.dateComponents([.day], from: base, to: target).day else { return 0 }
        
        return abs(diff)
    }
 
    private func lastRecordDiff(_ last: Date) -> Int {
        let today = Date()
        let baseDate = calendar.date(byAdding: .day, value: -1, to: today) ?? Date()
        
        return calculateRecordDiff(base: baseDate, target: last)
    }
}
