//
//  PauseCardViewModel.swift
//  HappBit
//
//  Created by 아라 on 10/23/24.
//

import Foundation
import Combine

class PauseCardViewModel: ViewModelType {
    var cancellables = Set<AnyCancellable>()
    var input = Input()
    @Published
    var output = Output()
    
    init() {
        transform()
    }
}

extension PauseCardViewModel {
    struct Input {
        var viewOnAppear = PassthroughSubject<HabitEntity, Never>()
    }
    
    struct Output {
        var lastConsecutiveDate: String = ""
        var countConsecutiveDays: Int = 0
        var cloverCount: Int = 0
    }
    
    func transform() {
        input
            .viewOnAppear
            .sink { [weak self] habit in
                guard let self,
                      let records = habit.practiceRecords?.allObjects as? Array<RecordEntity> else { return }
                let dates = records.compactMap { $0.date }.sorted { $0 > $1 }
                if let lastDate = dates.last {
                    output.lastConsecutiveDate = "마지막 실천일 : " + lastDate.toString()
                }
                
                output.countConsecutiveDays = manager.calculateConsecutiveDays(dates)
                output.cloverCount = manager.calculateCloverCount(dates)
            }.store(in: &cancellables)
    }
}

// MARK: Action
extension PauseCardViewModel {
    enum Action {
        case viewOnAppear(habit: HabitEntity)
    }
    
    func action(_ action: Action) {
        switch action {
        case .viewOnAppear(let habit):
            input.viewOnAppear.send(habit)
        }
    }
}
