//
//  ViewModelType.swift
//  HappBit
//
//  Created by 아라 on 9/23/24.
//

import Foundation
import Combine

protocol ViewModelType: AnyObject, ObservableObject {
    associatedtype Input
    associatedtype Output
    
    var cancellables: Set<AnyCancellable> { get set }
    var manager: CoreDataManager { get }
    
    var input: Input { get set }
    var output: Output { get set }
    
    func transform()
}

extension ViewModelType {
    var manager: CoreDataManager {
        return CoreDataManager.shared
    }
}
