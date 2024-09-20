//
//  Habit.swift
//  HappBit
//
//  Created by 아라 on 9/20/24.
//

import Foundation
import RealmSwift

final class Habit: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String
    @Persisted var category: Category
    @Persisted var habitualization: List<Calendar>
    @Persisted var cloverCount: Int
    @Persisted var createdAt: Date
    @Persisted var endDate: Date?
    
    convenience init(title: String,
                     category: Category,
                     habitualization: List<Calendar> = List(),
                     cloverCount: Int = 0,
                     createdAt: Date = Date(),
                     endDate: Date? = nil) {
        self.init()
        self.title = title
        self.category = category
        self.habitualization = habitualization
        self.cloverCount = cloverCount
        self.createdAt = createdAt
        self.endDate = endDate
    }
}

final class Category: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String
    @Persisted var color: String
    
    convenience init(title: String, color: String) {
        self.init()
        self.title = title
        self.color = color
    }
}

final class Calendar: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var month: Int
    @Persisted var day: Int
    
    convenience init(month: Int, day: Int) {
        self.init()
        self.month = month
        self.day = day
    }
}
