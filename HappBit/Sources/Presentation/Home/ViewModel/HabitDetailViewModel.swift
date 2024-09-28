//
//  HabitDetailViewModel.swift
//  HappBit
//
//  Created by 아라 on 9/26/24.
//

import Foundation
import Combine

class HabitDetailViewModel: ViewModelType {
    var cancellables = Set<AnyCancellable>()
    var input = Input()
    @Published
    var output = Output()
    
    init() {
        transform()
    }
}

// MARK: Input/Output
extension HabitDetailViewModel {
    struct Input {
        var viewOnAppear = PassthroughSubject<(Habit, PracticeStatus), Never>()
        var editBtnDidTap = PassthroughSubject<Habit, Never>()
        var pauseBtnDidTap = PassthroughSubject<Void, Never>()
        var pauseAgreeBtnDidTap = PassthroughSubject<Habit, Never>()
    }
    
    struct Output {
        var data: (Habit, PracticeStatus) = (Habit(), PracticeStatus())
        var showEditHabitView: Habit = Habit()
        var showDeleteAlert: Bool = false
        var pauseHabit: Bool = false
    }
    
    func transform() {
        input
            .viewOnAppear
            .sink { [weak self] values in
                guard let self else { return }
                output.data = values
            }.store(in: &cancellables)
        
        input
            .editBtnDidTap
            .sink { [weak self] habit in
                guard let self else { return }
                output.showEditHabitView = habit
            }.store(in: &cancellables)
        
        input
            .pauseBtnDidTap
            .sink { [weak self] _ in
                guard let self else { return }
                output.showDeleteAlert = true
            }.store(in: &cancellables)
        
        input
            .pauseAgreeBtnDidTap
            .sink { [weak self] habit in
                guard let self else { return }
                output.pauseHabit = true
                habit.pauseHabit()
                output.data = (Habit(), PracticeStatus())
            }.store(in: &cancellables)
    }
}

// MARK: Action
extension HabitDetailViewModel {
    enum Action {
        case viewOnAppear(habit: Habit, status: PracticeStatus)
        case editBtnDidTap(habit: Habit)
        case pauseBtnDidTap
        case pauseAgreeBtnDidTap(habit: Habit)
    }
    
    func action(_ action: Action) {
        switch action {
        case .viewOnAppear(let habit, let status):
            input.viewOnAppear.send((habit, status))
        case .editBtnDidTap(let habit):
            input.editBtnDidTap.send(habit)
        case .pauseBtnDidTap:
            input.pauseBtnDidTap.send(())
        case .pauseAgreeBtnDidTap(let habit):
            input.pauseAgreeBtnDidTap.send(habit)
        }
    }
}
