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
        var deleteBtnDidTap = PassthroughSubject<Void, Never>()
        var deleteAgreeBtnDidTap = PassthroughSubject<(Habit, PracticeStatus), Never>()
    }
    
    struct Output {
        var data: (Habit, PracticeStatus) = (Habit(), PracticeStatus())
        var showEditHabitView: Habit = Habit()
        var showDeleteAlert: Bool = false
        var deleteHabit: Bool = false
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
            .deleteBtnDidTap
            .sink { [weak self] _ in
                guard let self else { return }
                output.showDeleteAlert = true
            }.store(in: &cancellables)
        
        input
            .deleteAgreeBtnDidTap
            .sink { [weak self] values in
                guard let self else { return }
                output.deleteHabit = true
                Habit.deleteHabit(values.0, values.1)
                output.data = (Habit(), PracticeStatus())
            }.store(in: &cancellables)
    }
}

// MARK: Action
extension HabitDetailViewModel {
    enum Action {
        case viewOnAppear(habit: Habit, status: PracticeStatus)
        case editBtnDidTap(habit: Habit)
        case deleteBtnDidTap
        case deleteAgreeBtnDidTap(habit: Habit, status: PracticeStatus)
    }
    
    func action(_ action: Action) {
        switch action {
        case .viewOnAppear(let habit, let status):
            input.viewOnAppear.send((habit, status))
        case .editBtnDidTap(let habit):
            input.editBtnDidTap.send(habit)
        case .deleteBtnDidTap:
            input.deleteBtnDidTap.send(())
        case .deleteAgreeBtnDidTap(let habit, let status):
            input.deleteAgreeBtnDidTap.send((habit, status))
        }
    }
}
