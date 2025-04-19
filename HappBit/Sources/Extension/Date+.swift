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
    
    func toString(_ format: _DateFormatter) -> String {
        _DateFormatter.standard.timeStyle = .none
        _DateFormatter.standard.dateFormat = format.rawValue
        return _DateFormatter.standard.string(from: self)
    }
    
    func startOfDay() -> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        return Calendar.current.date(from: components)!
    }
}
