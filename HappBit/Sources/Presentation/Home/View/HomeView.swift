//
//  HomeView.swift
//  HappBit
//
//  Created by 아라 on 9/21/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    
    var body: some View {
        ScrollView {
            if viewModel.output.practiceStatusList.isEmpty {
                EmptyHabitView()
                    .scrollDisabled(true)
            }else {
                let matchedItems = viewModel.output.habitList.compactMap { habit in
                    viewModel.output.practiceStatusList.first { status in
                        status.habitID == habit.id
                    }.map { (habit, $0) }
                }
                
                ForEach(matchedItems, id: \.0.id) { habit, status in
                    HabitCardView(habit: habit, status: status)
                }
            }
        }
        .navigationTitle("HappBit")
        .background(Color.hbSecondary)
        .shadow(color: .gray.opacity(0.15), radius: 10)
        .onAppear {
            viewModel.action(.viewOnAppear)
        }
    }
}

struct EmptyHabitView: View {
    var body: some View {
        VStack {
            VStack {
                Text("현재 진행중인 습관이 없어요")
                Text("습관을 만들러 가볼까요?")
            }
            .padding(.top, 40)
            
            NavigationLink {
                AddHabitView()
            } label: {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.hbThirdary)
                    .frame(height: 80)
                    .overlay {
                        HStack {
                            Image(systemName: "plus.square")
                            Text("습관 형성하러 가기")
                                .padding(.leading, 5)
                        }
                        .foregroundStyle(Color.primary)
                        .font(.body1B)
                    }
            }
            .padding(.top, 20)
            .padding(.horizontal, 20)
            
            Spacer()
        }
        .foregroundStyle(Color.gray)
        .font(.body2M)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    NavigationView {
        HomeView()
    }
}
