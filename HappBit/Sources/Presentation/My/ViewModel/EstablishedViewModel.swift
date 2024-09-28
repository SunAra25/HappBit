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
                let statusList = Array(PracticeStatus.readPracticeStatusList())
                
                let matchedItems = habitList.compactMap { habit in
                    statusList.first { status in
                        status.habitID == habit.id
                    }.map { (habit, $0) }
                }
                output.habitList = matchedItems
            }.store(in: &cancellables)
    }
}

// MARK: Action
extension EstablishedViewModel {
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
