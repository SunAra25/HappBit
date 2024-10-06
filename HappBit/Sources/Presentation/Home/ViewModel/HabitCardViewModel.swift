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
    }
    
    struct Output {
        var habit: HabitEntity? = nil
        var countConsecutiveDays: Int = 0
        var records: [Date] = []
        var currentIndex: Int = 0
        var buttonAttribute: (ButtonAttribute, Bool) = (.complete, false)
    }
    
    func transform() {
        input
            .viewOnAppear
            .sink { [weak self] id in
                guard let self, let habit = manager.fetchHabit(id: id),
                let records = habit.practiceRecords as? Set<RecordEntity> else { return }
                let dates = records.compactMap { $0.date }.sorted()
                let count = countConsecutiveDays(dates)
                
                output.habit = habit
                output.countConsecutiveDays = count
                output.records = dates
                output.currentIndex = count > 0 ? count % 3 : 0
            }.store(in: &cancellables)
        
        input.setButton
            .sink { [weak self] index in
                guard let self,
                let records = output.habit?.practiceRecords as? Array<RecordEntity> else { return }
                let dates = records.compactMap { $0.date }.sorted()
                output.countConsecutiveDays = countConsecutiveDays(dates)
                let currentIndex = countConsecutiveDays(dates) > 0 ? countConsecutiveDays(dates) % 3 : 0
                if currentIndex < index {
                    guard let attr = ButtonAttribute(rawValue: 3) else { return }
                    output.buttonAttribute = (attr, true)
                } else {
                    guard let attr = ButtonAttribute(rawValue: index) else { return }
                    output.buttonAttribute = (attr, isRecordToday())
                }
            }.store(in: &cancellables)
    }
    
    func countConsecutiveDays(_ dates: [Date]) -> Int {
        guard !dates.isEmpty else { return 0 }
        let calendar = Calendar.current
        let sortedDates = dates.sorted(by: >)
        var currentCount = 0
        
        for i in 0..<sortedDates.count - 1 {
            let currentDate = sortedDates[i]
            let nextDate = sortedDates[i + 1]
            
            let currentDateStart = calendar.startOfDay(for: currentDate)
            let nextDateStart = calendar.startOfDay(for: nextDate)
            
            let dateGap = calendar.dateComponents([.day], from: nextDateStart, to: currentDateStart).day ?? 0
            
            if dateGap > 1 {
                return currentCount
            } else {
                currentCount += 1
            }
        }
        
        return currentCount
    }
    
    func isRecordToday() -> Bool {
        let calendar = Calendar.current
        return output.records.contains(where: { calendar.isDate($0, inSameDayAs: Date()) })
    }
}

// MARK: Action
extension HabitCardViewModel {
    enum Action {
        case viewOnAppear(id: NSManagedObjectID)
        case setButton(index: Int)
    }
    
    func action(_ action: Action) {
        switch action {
        case .viewOnAppear(let id):
            input.viewOnAppear.send(id)
        case .setButton(let index):
            input.setButton.send(index)
        }
    }
}
