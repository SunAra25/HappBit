
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
    
    func pauseHabit() {
        let realm = try! Realm()
        
        try! realm.write {
            endDate = Date()
        }
    }
    
    func restartHabit() {
        let realm = try! Realm()
        
        try! realm.write {
            endDate = nil
        }
    }
    
    func updateHabit(newTitle: String, newColorIdx: Int) {
        let realm = try! Realm()
        
        try! realm.write {
            title = newTitle
            color = newColorIdx
        }
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
    @Persisted var currentIndex: Int = 0 // 현재 인덱스 0~2
    @Persisted var isTodayList: List<Bool>
    
    convenience init(habitID: ObjectId) {
        self.init()
        self.habitID = habitID
        self.isTodayList.append(objectsIn: [false, false, false])
    }
    
    func recordPractice() {
        let realm = try! Realm()
        
        try! realm.write {
            isTodayList.replace(index: currentIndex, object: true)
            consecutiveDays += 1
            currentIndex = (consecutiveDays % 3)
            practiceDates.append(Date())
        }
    }
    
    // 오늘 실천 여부 체크
    func checkTodayPractice() -> Bool {
        let calendar = Calendar.current
        return practiceDates.contains(where: { calendar.isDate($0, inSameDayAs: Date()) })
    }
    
    func checkYesterdayPractice() -> Bool {
        var calendar = Calendar.current
        
        guard let lastDate = practiceDates.last else { return true }
        let todayStart = calendar.startOfDay(for: Date())
        let lastDateStart = calendar.startOfDay(for: lastDate)
        
        let dateGap = calendar.dateComponents([.day], from: lastDateStart, to: todayStart).day ?? 0
        
        if dateGap > 1 {
            resetAll()
        }
        
        if !checkTodayPractice() && currentIndex == 0 && consecutiveDays > 0 {
            resetPracticeStatus()
        }
        
        return calendar.isDateInYesterday(lastDate)
    }
    
    func resetPracticeStatus() {
        let realm = try! Realm()
        
        try! realm.write {
            isTodayList.removeAll()
            isTodayList.append(objectsIn: [false, false, false])
        }
    }
    
    // 동그라미 상태 초기화
    func resetAll() {
        let realm = try! Realm()
        
        try! realm.write {
            currentIndex = 0
            consecutiveDays = 0
            isTodayList.removeAll()
            isTodayList.append(objectsIn: [false, false, false])
        }
    }
}

extension Habit {
    private static var realm = try! Realm()
    
    static func readProgressHabit() -> Results<Habit> {
        realm.objects(Habit.self)
            .filter("endDate == nil")
    }
    
    static func readEstablishedHabit() -> Results<Habit> {
        realm.objects(Habit.self)
            .filter("endDate != nil")
    }
    
    static func addHabit(_ habit: Habit) {
        try! realm.write {
            realm.add(habit)
            realm.add(PracticeStatus(habitID: habit.id))
        }
    }
    
    static func deleteHabit(_ habit: Habit, _ status: PracticeStatus) {
        try! realm.write {
            realm.delete(status)
            realm.delete(habit)
        }
    }
}

extension PracticeStatus {
    private static var realm = try! Realm()
    
    static func readPracticeStatusList() -> Results<PracticeStatus> {
        realm.objects(PracticeStatus.self)
    }
    
    static func readPracticeStatus(_ habitID: ObjectId) -> PracticeStatus {
        guard let status = realm.objects(PracticeStatus.self)
            .filter("habitID == %@", habitID).first else { return PracticeStatus(habitID: habitID) }
        return status
    }
    
    static func updatePracticeStatus(_ habitID: ObjectId) {
        try! realm.write {
            var status = PracticeStatus.readPracticeStatusList()
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
