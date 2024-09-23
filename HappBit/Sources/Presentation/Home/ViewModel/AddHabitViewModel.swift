//
//  AddHabitViewModel.swift
//  HappBit
//
//  Created by 아라 on 9/23/24.
//

import Foundation
import Combine

class AddHabitViewModel: ViewModelType {
    var cancellables = Set<AnyCancellable>()
    var input = Input()
    @Published
    var output = Output()
    
    init() {
        transform()
    }
}

// MARK: Input/Output
extension AddHabitViewModel {
    struct Input {
        var editingTitle = PassthroughSubject<String, Never>()
        var selectedColor = PassthroughSubject<Int?, Never>()
        var addHabit = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        var currentTitle: String = ""
        var currentColorIndex: Int?
        var buttonState: Bool = false
        var popView: Void = ()
    }
    
    func transform() {
        input
            .editingTitle
            .sink { [weak self] text in
                guard let self else { return }
                var text = text
                if text.count > 15 {
                    text.removeLast()
                }
                
                output.currentTitle = text
                output.buttonState = ((2...15) ~= text.count) && output.currentColorIndex != nil
            }.store(in: &cancellables)
        
        input
            .selectedColor
            .sink { [weak self] index in
                guard let self else { return }
                output.currentColorIndex = index
                output.buttonState = ((2...15) ~= output.currentTitle.count)
            }.store(in: &cancellables)
        
        input
            .addHabit
            .sink { [weak self] _ in
                guard let self, let colorIndex = output.currentColorIndex else { return }
                // TODO: Realm 저장
                print(output.currentTitle, colorIndex)
            }.store(in: &cancellables)
    }
}

// MARK: Action
extension AddHabitViewModel {
    enum Action {
        case editingTitle(text: String)
        case selectedColor(index: Int?)
        case addHabit
    }
    
    func action(_ action: Action) {
        switch action {
        case .editingTitle(let text):
            input.editingTitle.send(text)
        case .selectedColor(let index):
            input.selectedColor.send(index)
        case .addHabit:
            input.addHabit.send(())
        }
    }
}
