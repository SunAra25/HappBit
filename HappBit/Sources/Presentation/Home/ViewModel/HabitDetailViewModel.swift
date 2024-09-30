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
        var viewOnAppear = PassthroughSubject<Habit, Never>()
        var editBtnDidTap = PassthroughSubject<Bool, Never>()
        var pauseBtnDidTap = PassthroughSubject<Void, Never>()
        var pauseAgreeBtnDidTap = PassthroughSubject<Habit, Never>()
        var deleteBtnDidTap = PassthroughSubject<Void, Never>()
        var deleteAgreeBtnDidTap = PassthroughSubject<Habit, Never>()
    }
    
    struct Output {
        var data: Habit = Habit()
        var showEditHabitView: Bool = false
        var showPauseAlert: Bool = false
        var pauseHabit: Bool = false
        var showDeleteAlert: Bool = false
        var deleteHabit: Bool = false
    }
    
    func transform() {
        input
            .viewOnAppear
            .sink { [weak self] habit in
                guard let self else { return }
                output.data = habit
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
            .sink { [weak self] habit in
                guard let self else { return }
                Habit.deleteHabit(habit)
                output.data = Habit() // 초기화
                output.deleteHabit = true
            }.store(in: &cancellables)
    }
}

// MARK: Action
extension HabitDetailViewModel {
    enum Action {
        case viewOnAppear(habit: Habit)
        case editBtnDidTap
        case pauseBtnDidTap
        case pauseAgreeBtnDidTap(habit: Habit)
        case deleteBtnDidTap
        case deleteAgreeBtnDidTap(habit: Habit)
    }
    
    func action(_ action: Action) {
        switch action {
        case .viewOnAppear(let habit):
            input.viewOnAppear.send(habit)
        case .editBtnDidTap:
            input.editBtnDidTap.send(true)
        case .pauseBtnDidTap:
            input.pauseBtnDidTap.send(())
        case .pauseAgreeBtnDidTap(let habit):
            input.pauseAgreeBtnDidTap.send(habit)
        case .deleteBtnDidTap:
            input.deleteBtnDidTap.send(())
        case .deleteAgreeBtnDidTap(let habit):
            input.deleteAgreeBtnDidTap.send(habit)
        }
    }
}
