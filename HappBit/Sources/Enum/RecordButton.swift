//
//  RecordButton.swift
//  HappBit
//
//  Created by 아라 on 3/19/25.
//

import SwiftUI

enum ButtonImage: Int {
    case one = 0
    case two = 1
    case three = 2
    case complete = 3
    
    var name: String {
        switch self {
        case .one: "1.circle.fill"
        case .two: "2.circle.fill"
        case .three: "3.circle.fill"
        case .complete: "checkmark.circle.fill"
        }
    }
}

enum ButtonType {
    case complete(index: Int)
    case active(index: Int)
    case inactive
    
    var color: Color {
        switch self {
        case .complete(let index): Color.colorList[index]
        case .active(let index): Color.colorList[index].opacity(0.2)
        case .inactive: .gray.opacity(0.2)
        }
    }
}
