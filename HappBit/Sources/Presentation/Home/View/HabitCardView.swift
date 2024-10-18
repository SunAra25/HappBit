//
//  HabitCardView.swift
//  HappBit
//
//  Created by 아라 on 9/21/24.
//

import SwiftUI
import CoreData

enum ButtonAttribute: Int {
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
    @StateObject var viewModel = HabitCardViewModel()
    var habitID: NSManagedObjectID
    let colorList = [Color.hapRed, Color.hapYellow, Color.hapGreen, Color.hapMint, Color.hapBlue, Color.hapPurple]
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.hbThirdary)
            
            Text("☘️ × \(viewModel.output.countConsecutiveDays)")
                .foregroundStyle(.gray)
                .font(.captionM)
                .padding(20)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            
            VStack {
                Text(viewModel.output.habit?.title ?? "")
                    .font(.sub)
                    .fontWeight(.semibold)
                
                HStack {
                    ForEach(0..<3) { index in
                        if index < viewModel.output.currentIndex {
                            if let attr = ButtonAttribute(rawValue: 3),
                               let colorIndex = viewModel.output.habit?.colorIndex {
                                practiceButton(for: attr, color: colorList[Int(colorIndex)])
                            }
                        } else {
                            if let attr = ButtonAttribute(rawValue: index),
                               let colorIndex = viewModel.output.habit?.colorIndex {
                                practiceButton(for: attr, 
                                               color: viewModel.output.currentIndex < index || viewModel.output.isRecordToday ? .gray.opacity(0.2) : colorList[Int(colorIndex)].opacity(0.2))
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
        .onAppear {
            viewModel.action(.viewOnAppear(id: habitID))
        }
    }
    
    func practiceButton(for attribute: ButtonAttribute, color: Color) -> some View {
        Button {
            viewModel.action(.recordToday)
        } label: {
            Image(systemName: attribute.name)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 44)
                .padding(.horizontal, 4)
                .foregroundStyle(color)
        }
        .disabled(attribute == .complete || color == .gray.opacity(0.2))
    }
}

//#Preview {
//    HabitCardView(viewModel: HomeViewModel(), habit: Habit(title: "야호", color: 2), status: PracticeStatus(habitID: Habit(title: "야호", color: 2).id))
//}
