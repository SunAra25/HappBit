//
//  HabitCardView.swift
//  HappBit
//
//  Created by 아라 on 9/21/24.
//

import SwiftUI
import CoreData

struct HabitCardView: View {
    @StateObject var viewModel = HabitCardViewModel()
    var habitID: NSManagedObjectID
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.hbThirdary)
            
            Text("☘️ × \(viewModel.output.cloverCount)")
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
                        practiceButton(index: index)
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
    
    private func practiceButton(index: Int) -> some View {
        Button {
            viewModel.action(.recordToday)
        } label: {
            Image(systemName: viewModel.output.buttonAttributes[index].imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 44)
                .padding(.horizontal, 4)
                .foregroundStyle(viewModel.output.buttonAttributes[index].type.color)
        }
        .disabled(!viewModel.output.buttonAttributes[index].isEnable)
    }
}

//#Preview {
//    HabitCardView(viewModel: HomeViewModel(), habit: Habit(title: "야호", color: 2), status: PracticeStatus(habitID: Habit(title: "야호", color: 2).id))
//}
