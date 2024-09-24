//
//  HabitCardView.swift
//  HappBit
//
//  Created by 아라 on 9/21/24.
//

import SwiftUI

enum Status: Int {
    case one = 0
    case two = 1
    case three = 2
    case complete = 3
    
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
    @ObservedObject var viewModel: HomeViewModel
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
                    ForEach(0..<3) { index in
                        if status.isTodayList[index] {
                            if let practice = Status(rawValue: 3) {
                                practiceButton(for: practice, color: colorList[habit.color])
                            }
                        } else {
                            if let practice = Status(rawValue: index) {
                                practiceButton(for: practice, color: status.currentIndex == index ? colorList[habit.color].opacity(0.2) : .gray.opacity(0.2))
                            }
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
            viewModel.action(.completePractice(status: status))
        } label: {
            Image(systemName: practice.name)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 44)
                .padding(.horizontal, 4)
                .foregroundStyle(color)
        }
        .disabled(practice == .complete || color == .gray.opacity(0.2))
    }
}

#Preview {
    HabitCardView(viewModel: HomeViewModel(), habit: Habit(title: "야호", color: 2), status: PracticeStatus(habitID: Habit(title: "야호", color: 2).id))
}
