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
        var completePractice = PassthroughSubject<PracticeStatus, Never>()
        var addButtonTapped = PassthroughSubject<Void, Never>()
        var habitDidTap = PassthroughSubject<(Habit,PracticeStatus), Never>()
    }
    
    struct Output {
        var habitList: [Habit] = []
        var practiceStatusList: [PracticeStatus] = []
        var showAddHabitView: Bool = false
        var showDetailView: (Habit, PracticeStatus, Bool) = (Habit(), PracticeStatus(), false)
    }
    
    func transform() {
        input
            .viewOnAppear
            .sink { [weak self] _ in
                guard let self else { return }
                output.showDetailView = (Habit(), PracticeStatus(), false)
                output.habitList = Habit.readProgressHabit().map { $0 }
                output.practiceStatusList = PracticeStatus.readPracticeStatusList().map { $0 }
            }.store(in: &cancellables)
        
        input
            .completePractice
            .sink { [weak self] status in
                guard let self else { return }
                status.recordPractice()
                output.practiceStatusList = PracticeStatus.readPracticeStatusList().map { $0 }
            }.store(in: &cancellables)
        
        input
            .addButtonTapped
            .sink { [weak self] status in
                guard let self else { return }
                output.showAddHabitView = true
            }.store(in: &cancellables)
        
        input
            .habitDidTap
            .sink { [weak self] values in
                guard let self else { return }
                let (habit, status) = values
                output.showDetailView = (habit, status, true)
            }.store(in: &cancellables)
    }
}

// MARK: Action
extension HomeViewModel {
    enum Action {
        case viewOnAppear
        case completePractice(status: PracticeStatus)
        case addButtonTapped
        case habitDidTap(habit: Habit, status: PracticeStatus)
    }
    
    func action(_ action: Action) {
        switch action {
        case .viewOnAppear:
            input.viewOnAppear.send(())
        case .completePractice(let status):
            input.completePractice.send(status)
        case .addButtonTapped:
            input.addButtonTapped.send(())
        case .habitDidTap(let habit, let status):
            input.habitDidTap.send((habit, status))
        }
    }
}
