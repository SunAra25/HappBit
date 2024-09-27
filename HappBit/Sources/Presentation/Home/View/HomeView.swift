//
//  HomeView.swift
//  HappBit
//
//  Created by 아라 on 9/21/24.
//

import SwiftUI
import RealmSwift
struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    
    var body: some View {
        ScrollView {
            Text("행복한 습관을 실천해보아요☘️")
                .font(.body2M)
                .foregroundStyle(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
            
            if viewModel.output.practiceStatusList.isEmpty {
                EmptyHabitView(viewModel: viewModel)
                    .scrollDisabled(true)
            }else {
                let matchedItems = viewModel.output.habitList.compactMap { habit in
                    viewModel.output.practiceStatusList.first { status in
                        status.habitID == habit.id
                    }.map { (habit, $0) }
                }
                
                ForEach(matchedItems, id: \.0.id) { habit, status in
                    HabitCardView(viewModel: viewModel, habit: habit, status: status)
                }
            }
        }
        .background(Color.hbSecondary)
        .shadow(color: .gray.opacity(0.15), radius: 10)
        .onAppear {
            viewModel.action(.viewOnAppear)
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Text("햇빛")
                    .font(.head)
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.action(.addButtonTapped)
                } label: {
                    Image(systemName: "plus")
                        .foregroundStyle(Color.primary)
                }
            }
        }
        .navigationTitle("")
        .navigationDestination(isPresented: $viewModel.output.showAddHabitView) {
            AddHabitView()
        }
        .navigationDestination(isPresented: $viewModel.output.showDetailView.2) {
            HabitDetailView(habit: $viewModel.output.showDetailView.0, status: $viewModel.output.showDetailView.1)
        }
    }
}

struct EmptyHabitView: View {
    let viewModel: HomeViewModel
    
    var body: some View {
        VStack {
            VStack {
                Text("현재 진행중인 습관이 없어요")
                Text("습관을 만들러 가볼까요?")
            }
            .padding(.top, 40)
            
            Button {
                viewModel.action(.addButtonTapped)
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
