//
//  HomeViewModel.swift
//  HappBit
//
//  Created by 아라 on 9/24/24.
//

import Foundation
import Combine
import CoreData

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
//        var completeToday = PassthroughSubject<HabitEntity, Never>()
        var addButtonTapped = PassthroughSubject<Void, Never>()
        var habitDidTap = PassthroughSubject<HabitEntity, Never>()
    }
    
    struct Output {
        var habitList: [HabitEntity] = []
        var showAddHabitView: Bool = false
        var showDetailView: (HabitEntity?, Bool) = (nil, false)
    }
    
    func transform() {
        input
            .viewOnAppear
            .sink { [weak self] _ in
                guard let self else { return }
                output.habitList = manager.fetchHabit()
            }.store(in: &cancellables)
        
//        input
//            .completeToday
//            .sink { [weak self] habit in
//                guard let self else { return }
////                habit.completeToday()
//                reloadList()
//            }.store(in: &cancellables)
//
        input
            .addButtonTapped
            .sink { [weak self] status in
                guard let self else { return }
                output.showAddHabitView = true
            }.store(in: &cancellables)
        
        input
            .habitDidTap
            .sink { [weak self] habit in
                guard let self else { return }
                output.showDetailView = (habit, true)
            }.store(in: &cancellables)
    }
}

// MARK: Action
extension HomeViewModel {
    enum Action {
        case viewOnAppear
//        case completeToday(habit: Habit)
        case addButtonTapped
        case habitDidTap(habit: HabitEntity)
    }
    
    func action(_ action: Action) {
        switch action {
        case .viewOnAppear:
            input.viewOnAppear.send(())
//        case .completeToday(let habit):
//            input.completeToday.send(habit)
        case .addButtonTapped:
            input.addButtonTapped.send(())
        case .habitDidTap(let habit):
            input.habitDidTap.send(habit)
        }
    }
}
