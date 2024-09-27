////
////  ViewData.swift
////  HappBit
////
////  Created by 아라 on 9/27/24.
////
//
//import Foundation
//
//struct _Habit: Identifiable {
//    let id: String
//    var title: String
//    var color: Int
//    let createdAt: Date
//    var endDate: Date?
//    
//    init() {
//        self.init(id: "", title: "", color: 0)
//    }
//    
//    init(id: String, title: String, color: Int, createdAt: Date = Date(), endDate: Date? = nil) {
//        self.id = id
//        self.title = title
//        self.color = color
//        self.createdAt = createdAt
//        self.endDate = endDate
//    }
//    
//    init(habit: Habit) {
//        self.id = habit.id.stringValue
//        self.title = habit.title
//        self.color = habit.color
//        self.createdAt = habit.createdAt
//        self.endDate = habit.endDate
//    }
//}
//
//struct _PracticeStatus: Identifiable {
//    let id: UInt64
//    let habitID: String
//    var practiceDates: [Date] = []
//    var consecutiveDays: Int = 0
//    var currentIndex: Int = 0
//    var isTodayList: [Bool] = [false, false, false]
//    
//    init() {
//        self.init(id: 0, habitID: "")
//    }
//    
//    init(id: UInt64, habitID: String) {
//        self.id = id
//        self.habitID = habitID
//    }
//    
//    init(status: PracticeStatus) {
//        self.id = status.id
//        self.habitID = status.habitID.stringValue
//    }
//}
