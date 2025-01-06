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

struct ButtonAttribute {
    let type: ButtonType
    let imageName: String
    let isEnable: Bool
}

// MARK: Input/Output
extension HabitCardViewModel {
    struct Input {
        var viewOnAppear = PassthroughSubject<NSManagedObjectID, Never>()
        var setButton = PassthroughSubject<Void, Never>()
        var recordToday =  PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        var habit: HabitEntity? = nil
        var countConsecutiveDays: Int = 0
        var cloverCount: Int = 0
        var records: [Date] = []
        var currentIndex: Int = 0
        var isRecordToday: Bool = false
        var buttonAttributes: [ButtonAttribute] = Array(repeating: ButtonAttribute(type: .inactive, imageName: "", isEnable: false), count: 3)
    }
    
    func transform() {
        input
            .viewOnAppear
            .sink { [weak self] id in
                guard let self, let habit = manager.fetchHabit(id: id) else { return }
                fetchRecord(to: habit)
            }.store(in: &cancellables)
        
        input
            .setButton
            .sink { [weak self] _ in
                guard let self, let habit = output.habit else { return }
                
                for index in 0..<3 {
                    var type: ButtonType = .inactive
                    var image: ButtonImage?
                    var isEnable = false
                    let isRecordToday = output.isRecordToday
                    let currentIdx = output.currentIndex
                    let isMultipleOfThree = currentIdx == 0 // 연속 실천일 수가 3의 배수인지?
                    let enableIdx = currentIdx - (isRecordToday ? 1 : 0 ) // 활성화 된 버튼의 index
                    let colorIdx = Int(habit.colorIndex)
                    
                    if index < currentIdx {
                        type = .complete(index: colorIdx)
                        image = ButtonImage(rawValue: 3)
                        isEnable = index == currentIdx - (isRecordToday ? 1 : 0)
                    } else {
                        type = index > enableIdx ? .inactive : isRecordToday ? .complete(index: colorIdx) : .active(index: colorIdx)
                        image = ButtonImage(rawValue: isMultipleOfThree && isRecordToday ? 3 : index)
                        isEnable = index == (isMultipleOfThree ? (isRecordToday ? 2 : 0) : enableIdx)
                    }
                    
                    guard let image else { return }
                    
                    output.buttonAttributes[index] = ButtonAttribute(type: type, imageName: image.name, isEnable: isEnable)
                }
            }.store(in: &cancellables)
        
        input.recordToday
            .sink { [weak self] id in
                guard let self, let habit = output.habit else { return }
                
                if output.isRecordToday {
                    manager.cancelRecord(habit)
                } else {
                    manager.addRecord(habit)
                }
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
            action(.setButton)
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
        case setButton
        case recordToday
    }
    
    func action(_ action: Action) {
        switch action {
        case .viewOnAppear(let id):
            input.viewOnAppear.send(id)
        case .setButton:
            input.setButton.send(())
        case .recordToday:
            input.recordToday.send(())
        }
    }
}
