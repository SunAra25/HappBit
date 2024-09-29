//
//  HomeViewModel.swift
//  HappBit
//
//  Created by 아라 on 9/24/24.
//

import Foundation
import Combine
import RealmSwift

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
        var completeToday = PassthroughSubject<Habit, Never>()
        var addButtonTapped = PassthroughSubject<Void, Never>()
        var habitDidTap = PassthroughSubject<Habit, Never>()
    }
    
    struct Output {
        var habitList: Results<Habit> = Habit.readProgressHabit()
        var showAddHabitView: Bool = false
        var showDetailView: (Habit, Bool) = (Habit(), false)
    }
    
    func transform() {
        input
            .viewOnAppear
            .sink { [weak self] _ in
                guard let self else { return }
                reloadList()
                print(output.habitList, "🦊")
            }.store(in: &cancellables)
        
        input
            .completeToday
            .sink { [weak self] habit in
                guard let self else { return }
                habit.completeToday()
                reloadList()
            }.store(in: &cancellables)
        
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
    
    func reloadList() {
//        let habitList = Array(Habit.readProgressHabit())
//        
//        let validHabitList = habitList.filter { !$0.isInvalidated }
        
        output.habitList = Habit.readProgressHabit()
    }
}

// MARK: Action
extension HomeViewModel {
    enum Action {
        case viewOnAppear
        case completeToday(habit: Habit)
        case addButtonTapped
        case habitDidTap(habit: Habit)
    }
    
    func action(_ action: Action) {
        switch action {
        case .viewOnAppear:
            input.viewOnAppear.send(())
        case .completeToday(let habit):
            input.completeToday.send(habit)
        case .addButtonTapped:
            input.addButtonTapped.send(())
        case .habitDidTap(let habit):
            input.habitDidTap.send(habit)
        }
    }
}
