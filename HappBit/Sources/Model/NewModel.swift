//
//  NewModel.swift
//  HappBit
//
//  Created by 아라 on 9/29/24.
//

import Foundation
import RealmSwift

final class Habit: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String
    @Persisted var colorIndex: Int
    @Persisted var createdAt: Date
    @Persisted var endDate: Date?
    @Persisted var practiceDates: List<Date>
    @Persisted var consecutiveDays: Int = 0
    @Persisted var currentIndex: Int = 0
    @Persisted var isTodayList: List<Bool>
    
    // 초기화 시 PracticeStatus를 반드시 받아야 함
    convenience init(title: String, colorIndex: Int, createdAt: Date = Date()) {
        self.init()
        self.title = title
        self.colorIndex = colorIndex
        self.createdAt = createdAt
        self.isTodayList.append(objectsIn: [false, false, false])
    }
    
    func pauseHabit() {
//        let realm = try! Realm()
        
        try! Habit.realm.write {
            endDate = Date()
        }
    }
    
    func restartHabit() {
//        let realm = try! Realm()
        
        try! Habit.realm.write {
            endDate = nil
        }
    }
    
    func updateHabit(newTitle: String, newColorIdx: Int) {
//        let realm = try! Realm()
        
        try! Habit.realm.write {
            title = newTitle
            colorIndex = newColorIdx
        }
    }
    
    func completeToday() {
//        let realm = try! Realm()
        
        try! Habit.realm.write {
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
        let calendar = Calendar.current
        
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
    
    static func readPauseHabit() -> Results<Habit> {
        readEstablishedHabit()
            .filter("practiceDates.@count < 66")
    }

    static func addHabit(_ habit: Habit) {
        try! realm.write {
            realm.add(habit)
        }
    }

    static func deleteHabit(_ habit: Habit) {
        if let target = realm.object(ofType: Habit.self, forPrimaryKey: habit.id) {
            try! realm.write {
                realm.delete(target)
            }
        }
    }
}
