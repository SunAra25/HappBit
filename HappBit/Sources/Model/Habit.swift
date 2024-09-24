
//Habit.swift
//HappBit
//
//Created by 아라 on 9/20/24.


import Foundation
import RealmSwift

final class Habit: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String
    @Persisted var color: Int
    @Persisted var createdAt: Date
    @Persisted var endDate: Date?
    
    convenience init(title: String,
                     color: Int,
                     createdAt: Date = Date(),
                     endDate: Date? = nil) {
        self.init()
        self.title = title
        self.color = color
        self.createdAt = createdAt
        self.endDate = endDate
    }
}

//final class Category: Object, ObjectKeyIdentifiable {
//  @Persisted(primaryKey: true) var id: ObjectId
//  @Persisted var title: String
//  @Persisted var color: String
//  
//  convenience init(title: String, color: String) {
//      self.init()
//      self.title = title
//      self.color = color
//  }
//}

final class PracticeStatus: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var habitID: ObjectId
    @Persisted var practiceDates: List<Date> // 실천 날짜
    @Persisted var consecutiveDays: Int = 0 // 연속 실천 일수, 클로버 개수
    @Persisted var currentIndex: Int = 1 // 현재 인덱스 0~3
    
    convenience init(habitID: ObjectId) {
        self.init()
        self.habitID = habitID
    }
    
    func recordPractice(date: Date) {
        if !practiceDates.contains(date) {
            let calendar = Calendar.current
            guard let lastDate = practiceDates.last,
                  let yesterday = calendar.date(byAdding: .day, value: -1, to: date) else { return }
            
            if !calendar.isDate(yesterday, inSameDayAs: lastDate) {
                reset()
            }
            consecutiveDays += 1
            
            practiceDates.append(date)
        }
        
        currentIndex = min(currentIndex, 3)
    }
    
    // 오늘 실천 여부 체크
    func checkTodayPractice(date: Date) -> Bool {
        return practiceDates.contains(date)
    }
    
    // 동그라미 상태 초기화
    func reset() {
        consecutiveDays = 0
        currentIndex = 1
    }
}

extension Habit {
    private static var realm = try! Realm()
    
    static func readAllHabit() -> Results<Habit> {
        realm.objects(Habit.self)
    }
    
    static func addHabit(_ habit: Habit) {
        try! realm.write {
            realm.add(habit)
            realm.add(PracticeStatus(habitID: habit.id))
        }
    }
    
    static func deleteHabit(_ habit: Habit) {
        try! realm.write {
            realm.delete(habit)
        }
    }
}

extension PracticeStatus {
    private static var realm = try! Realm()
    
    static func readPracticeStatus() -> Results<PracticeStatus> {
        realm.objects(PracticeStatus.self)
//            .filter("habitID == %@", habitID)
    }
    
    static func updatePracticeStatus(_ habitID: ObjectId) {
        try! realm.write {
            var status = PracticeStatus.readPracticeStatus()
            guard let item = status.first else { return }
            item.practiceDates.append(Date())
        }
    }
    
    static func deleteHabit(_ habit: Habit) {
        try! realm.write {
            realm.delete(habit)
        }
    }
}
