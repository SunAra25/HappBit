//
//  HabitCardViewModel.swift
//  HappBit
//
//  Created by 아라 on 10/6/24.
//

import Foundation
import Combine
import CoreData

class HabitCardViewModel: ViewModelType {
    var cancellables = Set<AnyCancellable>()
    var input = Input()
    @Published
    var output = Output()
    
    init() {
        transform()
    }
}

// MARK: Input/Output
extension HabitCardViewModel {
    struct Input {
        var viewOnAppear = PassthroughSubject<NSManagedObjectID, Never>()
        var setButton = PassthroughSubject<Int, Never>()
        var recordToday =  PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        var habit: HabitEntity? = nil
        var countConsecutiveDays: Int = 0
        var cloverCount: Int = 0
        var records: [Date] = []
        var currentIndex: Int = 0
        var isRecordToday: Bool = false
        var buttonAttribute: (ButtonAttribute, Bool) = (.complete, false)
    }
    
    func transform() {
        input
            .viewOnAppear
            .sink { [weak self] id in
                guard let self, let habit = manager.fetchHabit(id: id) else { return }
                fetchRecord(to: habit)
            }.store(in: &cancellables)
        
        input.setButton
            .sink { [weak self] index in
                guard let self,
                let records = output.habit?.practiceRecords as? Array<RecordEntity> else { return }
                let dates = records.compactMap { $0.date }.sorted()
                
                if output.currentIndex < index {
                    guard let attr = ButtonAttribute(rawValue: 3) else { return }
                    output.buttonAttribute = (attr, true)
                } else {
                    guard let attr = ButtonAttribute(rawValue: index) else { return }
                    output.buttonAttribute = (attr, isRecordToday())
                }
            }.store(in: &cancellables)
        
        input.recordToday
            .sink { [weak self] id in
                guard let self, let habit = output.habit else { return }
                manager.addRecord(habit)
                fetchRecord(to: habit)
                output.isRecordToday = isRecordToday()
            }.store(in: &cancellables)
        
        func fetchRecord(to habit: HabitEntity) {
            guard let records = habit.practiceRecords as? Set<RecordEntity> else { return }
            let dates = records.compactMap { $0.date }.sorted { $0 > $1 }
            output.habit = habit
            output.countConsecutiveDays = manager.calculateConsecutiveDays(dates)
            output.cloverCount = manager.calculateCloverCount(dates)
            output.records = dates
            output.isRecordToday = isRecordToday()
            output.currentIndex = output.countConsecutiveDays > 0 ? output.countConsecutiveDays % 3 : 0
        }
    }
    
    func isRecordToday() -> Bool {
        let calendar = Calendar.current
        return output.records.contains(where: { calendar.isDateInToday($0) })
    }
}

// MARK: Action
extension HabitCardViewModel {
    enum Action {
        case viewOnAppear(id: NSManagedObjectID)
        case setButton(index: Int)
        case recordToday
    }
    
    func action(_ action: Action) {
        switch action {
        case .viewOnAppear(let id):
            input.viewOnAppear.send(id)
        case .setButton(let index):
            input.setButton.send(index)
        case .recordToday:
            input.recordToday.send(())
        }
    }
}
