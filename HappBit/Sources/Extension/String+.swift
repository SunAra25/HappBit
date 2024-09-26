//
//  String+.swift
//  HappBit
//
//  Created by 아라 on 9/26/24.
//

import Foundation

extension String {
    func toDate() -> Date? {
        _DateFormatter.standard.dateFormat = _DateFormatter.dateWithTime.rawValue
        return _DateFormatter.standard.date(from: self)
    }
}
