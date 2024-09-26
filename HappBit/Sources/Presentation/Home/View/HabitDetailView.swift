//
//  HabitDetailView.swift
//  HappBit
//
//  Created by 아라 on 9/26/24.
//

import SwiftUI

enum DetailData: String, CaseIterable {
    case all = "전체 실천일"
    case sequence = "연속 실천일"
    case clover = "획든한 클로버"
}

struct HabitDetailView: View {
    var habit: Habit = Habit(title: "하루에 물 2L", color: 3)
    var status: PracticeStatus = PracticeStatus(habitID: Habit(title: "dkfjief", color: 3).id)
    let colorList = [Color.hapRed, Color.hapYellow, Color.hapGreen, Color.hapMint, Color.hapBlue, Color.hapPurple]
    
    var body: some View {
        ScrollView {
            Text(habit.title)
                .font(.head)
            
            HStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(colorList[habit.color].opacity(0.15))
                    .frame(height: 120)
                    .overlay {
                        HStack {
                            ForEach(DetailData.allCases, id: \.self) { data in
                                dataView(data)
                            }
                        }
                    }
            }
            .padding()
        }
        .toolbar {
            Button {
                
            } label: {
                Image(systemName: "ellipsis")
            }
            .foregroundStyle(.primary)
        }
    }
    
    func dataView(_ data: DetailData) -> some View {
        VStack {
            Text(data.rawValue)
                .font(.body1M)
                .foregroundStyle(.gray)
                .padding(.horizontal, 4)
                .padding(.vertical, 4)
            switch data {
            case .all:
                Text("\(status.practiceDates.count)")
                    .font(.head)
            case .sequence:
                Text("\(status.consecutiveDays)")
                    .font(.head)
            case .clover:
                Text("\(status.consecutiveDays / 3)")
                    .font(.head)
            }
        }
    }
}

#Preview {
    NavigationView {
        HabitDetailView()
    }
}
