//
//  HabitCardView.swift
//  HappBit
//
//  Created by 아라 on 9/21/24.
//

import SwiftUI
import RealmSwift

enum Status: Int {
    case one = 1
    case two = 2
    case three = 3
    case complete = 0
    
    var name: String {
        switch self {
        case .one: "1.circle.fill"
        case .two: "2.circle.fill"
        case .three: "3.circle.fill"
        case .complete: "checkmark.circle.fill"
        }
    }
}

struct HabitCardView: View {
    let habit: Habit
    var status: PracticeStatus
    let colorList = [Color.hapRed, Color.hapYellow, Color.hapGreen, Color.hapMint, Color.hapBlue, Color.hapPurple]
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.hbThirdary)
            
            Text("☘️ × \(status.consecutiveDays / 3)")
                .foregroundStyle(.gray)
                .font(.captionM)
                .padding(20)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            
            VStack {
                Text(habit.title)
                    .font(.sub)
                    .fontWeight(.semibold)
                
                HStack {
                    ForEach(1..<4) { index in
                        switch index {
                        case ..<status.currentIndex:
                            if let practice = Status(rawValue: 0) {
                                practiceButton(for: practice, color: colorList[habit.color])
                            }
                        case status.currentIndex:
                            let isComplete = status.checkTodayPractice(date: Date())
                            if let practice = Status(rawValue: isComplete ? 0 : index) {
                                practiceButton(for: practice, color: isComplete ? colorList[habit.color] : colorList[habit.color].opacity(0.2))
                            }
                        case (status.currentIndex + 1)...:
                            if let practice = Status(rawValue: index) {
                                practiceButton(for: practice, color: .gray.opacity(0.2))
                            }
                        default:
                            EmptyView()
                        }
                    }
                }
                .padding(.top, 8)
            }
            .padding(.top)
        }
        .frame(height: 180)
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
    }
    
    func practiceButton(for practice: Status, color: Color) -> some View {
        Button {
            // 버튼 동작 정의
        } label: {
            Image(systemName: practice.name)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 44)
                .padding(.horizontal, 4)
                .foregroundStyle(color)
        }
    }
}

#Preview {
    HabitCardView(habit: Habit(title: "야호", color: 2), status: PracticeStatus(habitID: Habit(title: "야호", color: 12).id))
}
