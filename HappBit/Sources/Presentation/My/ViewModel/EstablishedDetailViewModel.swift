//
//  EstablishedDetailViewModel.swift
//  HappBit
//
//  Created by 아라 on 3/24/25.
//

import Foundation
import Combine
import CoreData

class EstablishedDetailViewModel: ViewModelType {
    var cancellables = Set<AnyCancellable>()
    var input = Input()
    @Published
    var output = Output()
    
    init() {
        transform()
    }
}

// MARK: Input/Output
extension EstablishedDetailViewModel {
    struct Input {
        var viewOnAppear = PassthroughSubject<NSManagedObjectID?, Never>()
        var changeMonthBtnDidTap = PassthroughSubject<Int, Never>()
    }
    
    struct Output {
        var title: String = ""
        var startDate: Date = Date()
        var endDate: Date = Date()
        var recordDays: Int = 0
        var cloverCount: Int = 0
        var records: [Date] = []
    }
    
    func transform() {
        input
            .viewOnAppear
            .sink { [weak self] id in
                guard let self, let id,
                      let habit = manager.fetchHabit(id: id),
                      let records = habit.practiceRecords?.allObjects as? Array<RecordEntity> else { return }
                
                output.title = habit.title ?? ""
                output.startDate = habit.createdAt ?? Date()
                output.endDate = habit.endDate ?? Date()
                output.recordDays = records.count
                let recordsDate = records.map { $0.date ?? Date() }
                output.records = recordsDate
                output.cloverCount = manager.calculateCloverCount(recordsDate)
            }.store(in: &cancellables)
    }
}

// MARK: Action
extension EstablishedDetailViewModel {
    enum Action {
        case viewOnAppear(id: NSManagedObjectID?)
        case changeMonthBtnDidTap(Int)
    }
    
    func action(_ action: Action) {
        switch action {
        case .viewOnAppear(let id):
            input.viewOnAppear.send(id)
        case .changeMonthBtnDidTap(let amount):
            input.changeMonthBtnDidTap.send(amount)
        }
    }
}
