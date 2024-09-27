//
//  PauseListView.swift
//  HappBit
//
//  Created by 아라 on 9/28/24.
//

import SwiftUI

struct PauseListView: View {
    
    var body: some View {
        ScrollView {
            PauseCardView()
        }
        .background(Color.hbSecondary)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Text("습관 보관함")
                    .font(.head)
            }
        }
    }
}

struct PauseCardView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.hbThirdary)
            
            Image(systemName: "ellipsis")
                .padding(20)
                .rotationEffect(.degrees(90))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            
            VStack {
                Text("오전 6시에 기상하기")
                    .font(.sub)
                
                Text("2023.04.11-2023.05.06")
                    .font(.body2M)
                    .foregroundStyle(.gray)
                    .padding(.vertical, 4)
                
                HStack {
                    Text("☘️ 21개")
                        .padding(8)
                        .overlay {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.gray.opacity(0.1))
                        }
                    
                    Text("실천 105일")
                        .padding(8)
                        .overlay {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.gray.opacity(0.1))
                        }
                }
                
                    .font(.body2M)
                    .foregroundStyle(.gray)
            }
            .padding(.top)
        }
        .frame(height: 160)
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
    }
}

#Preview {
    PauseListView()
}
