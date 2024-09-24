//
//  HomeViewModel.swift
//  HappBit
//
//  Created by 아라 on 9/24/24.
//

import Foundation
import Combine

class HomeViewModel: ViewModelType {
    var cancellables = Set<AnyCancellable>()
    var input = Input()
    @Published
    var output = Output()
    
    init() {
        transform()
    }
}

// MARK: Input/Output
extension HomeViewModel {
    struct Input {
        var viewOnAppear = PassthroughSubject<Void, Never>()
//        var practiceHabit = PassthroughSubject<Void, Never>()
//        var showAddHabitView = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        var habitList: [Habit] = []
        var practiceStatusList: [PracticeStatus] = []
    }
    
    func transform() {
        input
            .viewOnAppear
            .sink { [weak self] _ in
                guard let self else { return }
                output.habitList = Habit.readAllHabit().map { $0 }
                output.practiceStatusList = PracticeStatus.readPracticeStatus().map { $0 }
                print(output.habitList)
                print(output.practiceStatusList)
            }.store(in: &cancellables)
    }
}

// MARK: Action
extension HomeViewModel {
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
