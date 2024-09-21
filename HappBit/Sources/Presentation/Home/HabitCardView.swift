//
//  HabitCardView.swift
//  HappBit
//
//  Created by 아라 on 9/21/24.
//

import SwiftUI
import RealmSwift

struct HabitCardView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.hbThirdary)
            
            Text("☘️ × 12")
                .foregroundStyle(.gray)
                .font(.captionM)
                .padding(20)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            
            VStack {
                Text("🇺🇸 영어 회화 공부 30분만")
                    .font(.sub)
                    .fontWeight(.semibold)
                
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 44)
                        .padding(.horizontal, 4)
                        .foregroundStyle(Color.hapPurple)
                    
                    Image(systemName: "2.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 44)
                        .padding(.horizontal, 4)
                        .foregroundStyle(Color.hapPurple.opacity(0.2))
                    
                    Image(systemName: "3.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 44)
                        .padding(.horizontal, 4)
                        .foregroundStyle(.gray.opacity(0.2))
                }
                .padding(.top, 8)
            }
            .padding(.top)
        }
        .frame(height: 180)
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
    }
}

#Preview {
    HabitCardView()
}
