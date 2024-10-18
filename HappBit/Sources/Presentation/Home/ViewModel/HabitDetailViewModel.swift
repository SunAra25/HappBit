//
//  HabitDetailViewModel.swift
//  HappBit
//
//  Created by 아라 on 9/26/24.
//

import Foundation
import Combine
import RealmSwift
import CoreData

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
        var viewOnAppear = PassthroughSubject<NSManagedObjectID?, Never>()
        var editBtnDidTap = PassthroughSubject<Bool, Never>()
        var pauseBtnDidTap = PassthroughSubject<Void, Never>()
        var pauseAgreeBtnDidTap = PassthroughSubject<HabitEntity, Never>()
        var deleteBtnDidTap = PassthroughSubject<Void, Never>()
        var deleteAgreeBtnDidTap = PassthroughSubject<HabitEntity, Never>()
    }
    
    struct Output {
        var data: HabitEntity? = nil
        var showEditHabitView: Bool = false
        var showPauseAlert: Bool = false
        var pauseHabit: Bool = false
        var showDeleteAlert: Bool = false
        var deleteHabit: Bool = false
    }
    
    func transform() {
        input
            .viewOnAppear
            .sink { [weak self] habitID in
//                guard let self,
//                      let habitID,
//                      let habit = manager.fetchHabit(id: habitID) else { return }
//                output.data = habit
                print("🦁")
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
                manager.pauseHabit(habit)
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
                output.data = HabitEntity() // 초기화
                output.deleteHabit = true
            }.store(in: &cancellables)
    }
}

// MARK: Action
extension HabitDetailViewModel {
    enum Action {
        case viewOnAppear(habitID: NSManagedObjectID?)
        case editBtnDidTap
        case pauseBtnDidTap
        case pauseAgreeBtnDidTap(habit: HabitEntity)
        case deleteBtnDidTap
        case deleteAgreeBtnDidTap(habit: HabitEntity)
    }
    
    func action(_ action: Action) {
        switch action {
        case .viewOnAppear(let habitID):
            input.viewOnAppear.send(habitID)
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
