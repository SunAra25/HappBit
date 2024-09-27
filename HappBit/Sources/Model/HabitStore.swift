////
////  HabitStore.swift
////  HappBit
////
////  Created by 아라 on 9/27/24.
////
//
//import Foundation
//import RealmSwift
//
//class HabitStore: ObservableObject {
//    @ObservedResults(Habit.self) var habitObjectList
//    @ObservedResults(PracticeStatus.self) var statusObjectList
//    @Published var habitList: [Habit] = []
//    @Published var statusList: [_PracticeStatus] = []
//    @Published var matchedItems: [(_Habit, _PracticeStatus)] = []
//    
//    private var token: NotificationToken?
//    
//    init() {
//        setupObserver()
//    }
//    
//    deinit {
//        token?.invalidate()
//    }
//    
//    private func setupObserver() {
//        do {
//            let realm = try Realm()
//            let habitList = realm.objects(Habit.self)
//            let statusList = realm.objects(PracticeStatus.self)
//            
//            token = habitList.observe({ [weak self] changes in
//                guard let self else { return }
//                
//                self.habitList = habitList.map(_Habit.init)
//                    .sorted(by: { $0.createdAt < $1.createdAt })
//                
//                self.statusList = statusList.map(_PracticeStatus.init)
//                self.matchedItems = self.habitList.compactMap { habit in
//                    self.statusList.first { status in
//                        print(status.habitID)
//                        return status.habitID == habit.id
//                    }.map { (habit, $0) }
//                }
//                
//                print(habitList.map { $0.id })
//                print(statusList)
//            })
//        } catch let error {
//            print("옵저버 셋팅 실패")
//            print(error.localizedDescription)
//        }
//    }
//    
//    func readAllHabit() -> Results<Habit> {
//        let realm = try! Realm()
//        return realm.objects(Habit.self)
//    }
//    
//    func readAllStatus() -> Results<PracticeStatus> {
//        let realm = try! Realm()
//        return realm.objects(PracticeStatus.self)
//    }
//    
//    func addHabit(habit: Habit) {
//        $habitObjectList.append(habit)
//    }
//    
//    func addStatus(status: PracticeStatus) {
//        $statusObjectList.append(status)
//    }
//    
//    func deleteHabit(habit: _Habit) {
//        
//        do {
//            let realm = try Realm()
//            let objectId = habit.id
//            if let habit = realm.object(ofType: Habit.self, forPrimaryKey: objectId) {
//                try realm.write {
//                    realm.delete(habit)
//                }
//            }
//        } catch {
//            print("데이터 삭제 실패 : \(error)")
//        }
//    }
//    
//    func deleteStatus(status: _PracticeStatus) {
//        do {
//            let realm = try Realm()
//            let objectId = status.id
//            if let status = realm.object(ofType: PracticeStatus.self, forPrimaryKey: objectId) {
//                try realm.write {
//                    realm.delete(status)
//                }
//            }
//        } catch {
//            print("데이터 삭제 실패 : \(error)")
//        }
//    }
//    
//    func checkTodayPractice(status: PracticeStatus) -> Bool {
//        let calendar = Calendar.current
//        return status.practiceDates.contains(where: { calendar.isDate($0, inSameDayAs: Date()) })
//    }
//    
//    func checkYesterdayPractice(status: PracticeStatus) -> Bool {
//        var calendar = Calendar.current
//        calendar.timeZone = TimeZone(abbreviation: "UTC")!
//        
//        guard let lastDate = status.practiceDates.last else { return true }
//        guard let dateGap = calendar.dateComponents([.day], from: Date() , to: lastDate).day else {
//            return calendar.isDateInYesterday(lastDate)
//        }
//        
//        if dateGap > 0 {
//            resetAll(status: status)
//        }
//        
//        if !checkTodayPractice(status: status) && status.currentIndex == 0 && status.consecutiveDays > 0 {
//            resetPracticeStatus(status: status)
//        }
//        
//        return calendar.isDateInYesterday(lastDate)
//    }
//    
//    func resetPracticeStatus(status: PracticeStatus) {
//        let realm = try! Realm()
//        
//        try! realm.write {
//            status.consecutiveDays = 0
//            status.isTodayList.removeAll()
//            status.isTodayList.append(objectsIn: [false, false, false])
//        }
//    }
//    
//    // 동그라미 상태 초기화
//    func resetAll(status: PracticeStatus) {
//        let realm = try! Realm()
//        
//        try! realm.write {
//            status.currentIndex = 0
//            status.consecutiveDays = 0
//            status.isTodayList.removeAll()
//            status.isTodayList.append(objectsIn: [false, false, false])
//        }
//    }
//}
