//
//  HabitDetailViewModel.swift
//  HappBit
//
//  Created by 아라 on 9/26/24.
//

import Foundation
import Combine
import RealmSwift

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
        var editBtnDidTap = PassthroughSubject<Bool, Never>()
        var pauseBtnDidTap = PassthroughSubject<Void, Never>()
        var pauseAgreeBtnDidTap = PassthroughSubject<Habit, Never>()
        var deleteBtnDidTap = PassthroughSubject<Void, Never>()
        var deleteAgreeBtnDidTap = PassthroughSubject<(Habit, PracticeStatus), Never>()
    }
    
    struct Output {
        var data: (Habit, PracticeStatus) = (Habit(), PracticeStatus())
        var showEditHabitView: Bool = false
        var showPauseAlert: Bool = false
        var pauseHabit: Bool = false
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
            .sink { [weak self] isShowing in
                guard let self else { return }
                output.showEditHabitView = isShowing
            }.store(in: &cancellables)
        
        input
            .pauseBtnDidTap
            .sink { [weak self] _ in
                guard let self else { return }
                output.showPauseAlert = true
            }.store(in: &cancellables)
        
        input
            .pauseAgreeBtnDidTap
            .sink { [weak self] habit in
                guard let self else { return }
                output.pauseHabit = true
                habit.pauseHabit()
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
        case editBtnDidTap
        case pauseBtnDidTap
        case pauseAgreeBtnDidTap(habit: Habit)
        case deleteBtnDidTap
        case deleteAgreeBtnDidTap(habit: Habit, status: PracticeStatus)
    }
    
    func action(_ action: Action) {
        switch action {
        case .viewOnAppear(let habit, let status):
            input.viewOnAppear.send((habit, status))
        case .editBtnDidTap:
            input.editBtnDidTap.send(true)
        case .pauseBtnDidTap:
            input.pauseBtnDidTap.send(())
        case .pauseAgreeBtnDidTap(let habit):
            input.pauseAgreeBtnDidTap.send(habit)
        case .deleteBtnDidTap:
            input.deleteBtnDidTap.send(())
        case .deleteAgreeBtnDidTap(let habit, let status):
            input.deleteAgreeBtnDidTap.send((habit, status))
        }
    }
}
