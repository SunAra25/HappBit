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
        var restartBtnDidTap = PassthroughSubject<HabitEntity, Never>()
        var deleteBtnDidTap = PassthroughSubject<Void, Never>()
        var deleteAgreeBtnDidTap = PassthroughSubject<HabitEntity, Never>()
    }
    
    struct Output {
        var habitList: [HabitEntity] = []
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
                manager.restartHabit(habit)
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
                manager.deleteHabit(habit)
                output.deleteHabit = true
                reloadList()
            }.store(in: &cancellables)
    }
    
    func reloadList() {
        output.habitList = manager.fetchHabit().filter { $0.isPause }
    }
}

// MARK: Action
extension PauseListViewModel {
    enum Action {
        case viewOnAppear
        case restartBtnDidTap(habit: HabitEntity)
        case deleteBtnDidTap
        case deleteAgreeBtnDidTap(habit: HabitEntity)
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
