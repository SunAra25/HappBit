//
//  MyHabitViewModel.swift
//  HappBit
//
//  Created by 아라 on 9/27/24.
//

import Foundation
import Combine

class EstablishedViewModel: ViewModelType {
    var cancellables = Set<AnyCancellable>()
    var input = Input()
    @Published
    var output = Output()
    
    init() {
        transform()
    }
}

// MARK: Input/Output
extension EstablishedViewModel {
    struct Input {
        var viewOnAppear = PassthroughSubject<Void, Never>()
        var rowDidTap = PassthroughSubject<HabitEntity, Never>()
    }
    
    struct Output {
        var habitList: [HabitEntity] = []
        var counts: Int = 0
        var consecutiveDays: Int = 0
        var showDetailView: Bool = false
        var detailHabit: HabitEntity?
    }
    
    func transform() {
        input
            .viewOnAppear
            .sink { [weak self] _ in
                guard let self else { return }
                output.habitList = manager.fetchHabit().filter { $0.endDate != nil }
                output.counts = output.habitList.count
                
                let records = output.habitList.map { [weak self] habit in
                    guard let self,
                          let records = habit.practiceRecords?.allObjects as? Array<RecordEntity> else { return [] }
                    return records
                }
                
                output.consecutiveDays = records.reduce(0) { $0 + $1.count }
            }.store(in: &cancellables)
        
        input
            .rowDidTap
            .sink { [weak self] habit in
                guard let self else { return }
                output.detailHabit = habit
                output.showDetailView.toggle()
            }.store(in: &cancellables)
    }
}

// MARK: Action
extension EstablishedViewModel {
    enum Action {
        case viewOnAppear
        case rowDidTap(HabitEntity)
    }
    
    func action(_ action: Action) {
        switch action {
        case .viewOnAppear:
            input.viewOnAppear.send(())
        case .rowDidTap(let habit):
            input.rowDidTap.send(habit)
        }
    }
}
