//
//  AddHabitViewModel.swift
//  HappBit
//
//  Created by 아라 on 9/23/24.
//

import Foundation
import Combine

class UpdateHabitViewModel: ViewModelType {
    var cancellables = Set<AnyCancellable>()
    var input = Input()
    @Published
    var output = Output()
    
    init() {
        transform()
    }
}

// MARK: Input/Output
extension UpdateHabitViewModel {
    struct Input {
        var viewOnAppear = PassthroughSubject<UpdateType, Never>()
        var editingTitle = PassthroughSubject<String, Never>()
        var selectedColor = PassthroughSubject<Int?, Never>()
        var addHabit = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        var updateType: UpdateType = .add
        var currentTitle: String = ""
        var currentColorIndex: Int?
        var buttonState: Bool = false
        var popView: Bool = false
    }
    
    func transform() {
        input
            .viewOnAppear
            .sink { [weak self] type in
                guard let self else { return }
                switch type {
                case .add: break
                case .edit(let habit):
                    output.updateType = .edit(habit: habit)
                    output.currentTitle = habit.title
                    output.currentColorIndex = habit.color
                }
            }.store(in: &cancellables)
        
        input
            .editingTitle
            .sink { [weak self] text in
                guard let self else { return }
                var text = text
                if text.count > 15 {
                    text.removeLast()
                }
                
                output.currentTitle = text
                output.buttonState = checkButtonEnable()
            }.store(in: &cancellables)
        
        input
            .selectedColor
            .sink { [weak self] index in
                guard let self else { return }
                output.currentColorIndex = index
                output.buttonState = checkButtonEnable()
            }.store(in: &cancellables)
        
        input
            .addHabit
            .sink { [weak self] _ in
                guard let self, let colorIndex = output.currentColorIndex else { return }
                Habit.addHabit(Habit(title: output.currentTitle, color: colorIndex))
                output.popView = true
            }.store(in: &cancellables)
    }
    
    func checkButtonEnable() -> Bool {
        switch output.updateType {
        case .add:
            return ((2...15) ~= output.currentTitle.count) && output.currentColorIndex != nil
        case .edit(let habit):
            return ((2...15) ~= output.currentTitle.count) && output.currentColorIndex != nil && (output.currentTitle != habit.title || output.currentColorIndex != habit.color)
        }
    }
}

// MARK: Action
extension UpdateHabitViewModel {
    enum Action {
        case viewOnAppear(type: UpdateType)
        case editingTitle(text: String)
        case selectedColor(index: Int?)
        case addHabit
    }
    
    func action(_ action: Action) {
        switch action {
        case .viewOnAppear(let type):
            input.viewOnAppear.send(type)
        case .editingTitle(let text):
            input.editingTitle.send(text)
        case .selectedColor(let index):
            input.selectedColor.send(index)
        case .addHabit:
            input.addHabit.send(())
        }
    }
}
