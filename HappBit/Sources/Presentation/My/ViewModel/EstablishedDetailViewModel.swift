//
//  EstablishedDetailViewModel.swift
//  HappBit
//
//  Created by 아라 on 3/24/25.
//

import Foundation
import Combine
import CoreData

class EstablishedDetailViewModel: ViewModelType {
    var cancellables = Set<AnyCancellable>()
    var input = Input()
    @Published
    var output = Output()
    
    init() {
        transform()
    }
}

// MARK: Input/Output
extension EstablishedDetailViewModel {
    struct Input {
        var viewOnAppear = PassthroughSubject<NSManagedObjectID?, Never>()
        var changeMonthBtnDidTap = PassthroughSubject<Int, Never>()
    }
    
    struct Output {
        var title: String = ""
        var startDate: Date = Date()
        var endDate: Date = Date()
        var colorIndex: Int = 0
        var recordDays: Int = 0
        var cloverCount: Int = 0
        var records: [[Date]] = []
        var currentMonth: Date = Date()
        var daysInMonth: Int = 0
        var firstWeekday: Int = 0
    }
    
    func transform() {
        input
            .viewOnAppear
            .sink { [weak self] id in
                guard let self, let id,
                      let habit = manager.fetchHabit(id: id),
                      let records = habit.practiceRecords?.allObjects as? Array<RecordEntity> else { return }
                
                output.title = habit.title ?? ""
                output.startDate = habit.createdAt ?? Date()
                output.endDate = habit.endDate ?? Date()
                output.colorIndex = Int(habit.colorIndex)
                output.recordDays = records.count
                let recordsDate = records.map { $0.date ?? Date() }
                output.records = groupConsecutiveDates(recordsDate)
                output.cloverCount = manager.calculateCloverCount(recordsDate)
                
                output.daysInMonth = numberOfDays(in: output.currentMonth)
                output.firstWeekday = firstWeekdayOfMonth(in: output.currentMonth)
            }.store(in: &cancellables)
        
        input
            .changeMonthBtnDidTap
            .sink { [weak self] amount in
                guard let self,
                      let newMonth = Calendar.current.date(byAdding: .month, value: amount, to: output.currentMonth) else { return }
                output.currentMonth = newMonth
                output.daysInMonth = numberOfDays(in: newMonth)
                output.firstWeekday = firstWeekdayOfMonth(in: newMonth)
            }.store(in: &cancellables)
    }
}

// MARK: Action
extension EstablishedDetailViewModel {
    enum Action {
        case viewOnAppear(id: NSManagedObjectID?)
        case changeMonthBtnDidTap(Int)
    }
    
    func action(_ action: Action) {
        switch action {
        case .viewOnAppear(let id):
            input.viewOnAppear.send(id)
        case .changeMonthBtnDidTap(let amount):
            input.changeMonthBtnDidTap.send(amount)
        }
    }
}

private extension EstablishedDetailViewModel {
    func groupConsecutiveDates(_ dates: [Date]) -> [[Date]] {
        let calendar = Calendar.current
        let dates = dates.sorted { $0 > $1 }

        var result: [[Date]] = []
        var currentGroup: [Date] = []

        for date in dates {
            if currentGroup.isEmpty {
                currentGroup.append(date)
            } else {
                let preDate = currentGroup.first!
                
                guard let diff = calendar.dateComponents([.day], from: preDate, to: date).day else { return [] }
                if abs(diff) <= 1 {
                    currentGroup.append(date)
                } else {
                    result.append(currentGroup)
                    currentGroup = [date]
                }
            }
        }

        if !currentGroup.isEmpty {
            result.append(currentGroup)
        }
        
        return result
    }
    
    func numberOfDays(in date: Date) -> Int {
        return Calendar.current.range(of: .day, in: .month, for: date)?.count ?? 0
    }
    
    func firstWeekdayOfMonth(in date: Date) -> Int {
        let components = Calendar.current.dateComponents([.year, .month], from: date)
        let firstDayOfMonth = Calendar.current.date(from: components)!
        
        return Calendar.current.component(.weekday, from: firstDayOfMonth)
    }
}
