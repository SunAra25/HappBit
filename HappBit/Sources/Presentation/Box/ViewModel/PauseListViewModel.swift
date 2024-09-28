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
        var restartBtnDidTap = PassthroughSubject<Habit, Never>()
    }
    
    struct Output {
        var habitList: [(Habit, PracticeStatus)] = []
    }
    
    func transform() {
        input
            .viewOnAppear
            .sink { [weak self] _ in
                guard let self else { return }
                reloadList()
            }.store(in: &cancellables)
        
        input
            .restartBtnDidTap
            .sink { [weak self] habit in
                guard let self else { return }
                habit.restartHabit()
                reloadList()
            }.store(in: &cancellables)
    }
    
    func reloadList() {
        let habitList = Array(Habit.readEstablishedHabit())
        let statusList = Array(PracticeStatus.readPracticeStatusList()).filter { $0.consecutiveDays < 66 }
        
        let matchedItems = statusList.compactMap { status in
            habitList.first { habit in
                status.habitID == habit.id
            }.map { ($0, status) }
        }
        
        output.habitList = matchedItems
    }
}

// MARK: Action
extension PauseListViewModel {
    enum Action {
        case viewOnAppear
        case restartBtnDidTap(habit: Habit)
    }
    
    func action(_ action: Action) {
        switch action {
        case .viewOnAppear:
            input.viewOnAppear.send(())
        case .restartBtnDidTap(let habit):
            input.restartBtnDidTap.send(habit)
        }
    }
}
