//
//  PauseListViewModel.swift
//  HappBit
//
//  Created by 아라 on 9/28/24.
//

import Foundation
import Combine
import RealmSwift

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
        var deleteBtnDidTap = PassthroughSubject<Void, Never>()
        var deleteAgreeBtnDidTap = PassthroughSubject<Habit, Never>()
    }
    
    struct Output {
        var habitList: Results<Habit> = Habit.readPauseHabit()
        var showDeleteAlert: Bool = false
        var deleteHabit: Bool = false
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
                output.deleteHabit = true
                reloadList()
            }.store(in: &cancellables)
    }
    
    func reloadList() {
        output.habitList = Habit.readPauseHabit()
    }
}

// MARK: Action
extension PauseListViewModel {
    enum Action {
        case viewOnAppear
        case restartBtnDidTap(habit: Habit)
        case deleteBtnDidTap
        case deleteAgreeBtnDidTap(habit: Habit)
    }
    
    func action(_ action: Action) {
        switch action {
        case .viewOnAppear:
            input.viewOnAppear.send(())
        case .restartBtnDidTap(let habit):
            input.restartBtnDidTap.send(habit)
        case .deleteBtnDidTap:
            input.deleteBtnDidTap.send(())
        case .deleteAgreeBtnDidTap(let habit):
            input.deleteAgreeBtnDidTap.send(habit)
        }
    }
}
