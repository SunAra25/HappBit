//
//  CircleProgressView.swift
//  HappBit
//
//  Created by 아라 on 3/18/25.
//

import SwiftUI

struct CircleProgressView: View {
    let color: Color
    let count: Int
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    Color.gray.opacity(0.1),
                    lineWidth: 40
                )
            
            Circle()
                .trim(from: 0, to: CGFloat(count) / 66)
                .stroke(
                    color,
                    style: StrokeStyle(
                        lineWidth: 40,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
            
            Text("\(Int(CGFloat(count) / 66 * 100))%")
                .font(.highlight)
        }
        .padding(.horizontal, 60)
    }
}

#Preview {
    CircleProgressView(color: Color.pink, count: 21)
}
