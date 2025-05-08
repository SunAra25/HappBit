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
                var list = manager.fetchHabit().filter { $0.endDate == nil }
                list.sort { $0.createdAt ?? Date() > $1.createdAt ?? Date() }
                output.habitList = list
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
}

// MARK: Action
extension HomeViewModel {
    enum Action {
        case viewOnAppear
        case addButtonTapped
        case habitDidTap(habit: HabitEntity)
    }
    
    func action(_ action: Action) {
        switch action {
        case .viewOnAppear:
            input.viewOnAppear.send(())
        case .addButtonTapped:
            input.addButtonTapped.send(())
        case .habitDidTap(let habit):
            input.habitDidTap.send(habit)
        }
    }
}
