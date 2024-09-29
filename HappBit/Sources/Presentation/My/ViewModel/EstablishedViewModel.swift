//
//  MyHabitViewModel.swift
//  HappBit
//
//  Created by 아라 on 9/27/24.
//

import Foundation
import Combine
import RealmSwift

class EstablishedViewModel: ViewModelType {
    var cancellables = Set<AnyCancellable>()
    var input = Input()
    @Published
    var output = Output()
    
    init() {
        transform()
    }
}

// MARK: Input/Output
extension EstablishedViewModel {
    struct Input {
        var viewOnAppear = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        var habitList: Results<Habit> = Habit.readEstablishedHabit()
    }
    
    func transform() {
        input
            .viewOnAppear
            .sink { [weak self] _ in
                guard let self else { return }
                output.habitList = Habit.readEstablishedHabit()
            }.store(in: &cancellables)
    }
}

// MARK: Action
extension EstablishedViewModel {
    enum Action {
        case viewOnAppear
    }
    
    func action(_ action: Action) {
        switch action {
        case .viewOnAppear:
            input.viewOnAppear.send(())
        }
    }
}
