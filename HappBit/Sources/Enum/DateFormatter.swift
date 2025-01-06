//
//  DateFormatter.swift
//  HappBit
//
//  Created by 아라 on 9/26/24.
//

import Foundation

enum _DateFormatter: String {
    static let standard = DateFormatter()
    
    case dateWithTime = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    case date = "yyyy년 M월 d일"
    case header = "yyyy.MM"
}
