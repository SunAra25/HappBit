//
//  PauseListViewModel.swift
//  HappBit
//
//  Created by 아라 on 9/28/24.
//

import Foundation
import Combine

class PauseListViewModel: ViewModelType {
    var cancellables = Set<AnyCancellable>()
    var input = Input()
    @Published
    var output = Output()
    
    init() {
        transform()
    }
}

// MARK: Input/Output
extension PauseListViewModel {
    struct Input {
        var viewOnAppear = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        var habitList: [(Habit, PracticeStatus)] = []
    }
    
    func transform() {
        input
            .viewOnAppear
            .sink { [weak self] _ in
                guard let self else { return }
                let habitList = Array(Habit.readEstablishedHabit())
                let statusList = Array(PracticeStatus.readPracticeStatusList()).filter { $0.consecutiveDays < 66 }
                
                let matchedItems = statusList.compactMap { status in
                    habitList.first { habit in
                        status.habitID == habit.id
                    }.map { ($0, status) }
                }
                
                output.habitList = matchedItems
            }.store(in: &cancellables)
    }
}

// MARK: Action
extension PauseListViewModel {
    enum Action {
        case viewOnAppear
    }
    
    func action(_ action: Action) {
        switch action {
        case .viewOnAppear:
            input.viewOnAppear.send(())
        }
    }
}
