//
//  Font+.swift
//  HappBit
//
//  Created by 아라 on 9/20/24.
//

import SwiftUI

extension Font {
    public enum FontType: String{
        case bold = "Bold"
        case medium = "Medium"
    }
    
    static func Pretendard(_ type: FontType, size: CGFloat) -> Font {
        return .custom("Pretendard-\(type.rawValue)", size: size)
    }
}

extension Font {
    static let highlight = Font.Pretendard(.bold, size: 48)
    static let head = Font.Pretendard(.bold, size: 22)
    static let sub = Font.Pretendard(.bold, size: 20)
    static let body1B = Font.Pretendard(.bold, size: 16)
    static let body1M = Font.Pretendard(.medium, size: 16)
    static let body2B = Font.Pretendard(.bold, size: 14)
    static let body2M = Font.Pretendard(.medium, size: 14)
    static let captionB = Font.Pretendard(.bold, size: 13)
    static let captionM = Font.Pretendard(.medium, size: 13)
}
