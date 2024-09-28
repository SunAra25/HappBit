//
//  SubTitleWrapper.swift
//  HappBit
//
//  Created by 아라 on 9/28/24.
//

import Foundation
import SwiftUI

private struct SubTitleWrapper: ViewModifier {
     func body(content: Content) -> some View {
        content
            .font(.body2M)
            .foregroundStyle(.gray)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
    }
    
}

extension View {
    func asSubTitle() -> some View {
        modifier(SubTitleWrapper())
    }
}
