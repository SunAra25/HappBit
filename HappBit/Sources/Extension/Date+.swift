//
//  Date+.swift
//  HappBit
//
//  Created by 아라 on 9/26/24.
//

import Foundation

extension Date {
    func toString() -> String {
        _DateFormatter.standard.timeStyle = .none
        _DateFormatter.standard.dateFormat = _DateFormatter.date.rawValue
        return _DateFormatter.standard.string(from: self)
    }
}
