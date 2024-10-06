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
            Text("행복한 습관을 실천해보아요 ☘️")
                .asSubTitle()
            
            if viewModel.output.habitList.isEmpty {
                EmptyHabitView(viewModel: viewModel)
                    .scrollDisabled(true)
            } else {
                ForEach(viewModel.output.habitList, id: \.id) { habit in
                    HabitCardView(habitID: habit.objectID)
                }
            }
        }
        .background(Color.hbSecondary)
        .shadow(color: .gray.opacity(0.15), radius: 10)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Text("happbit")
                    .font(.head)
            }
            
            if !viewModel.output.habitList.isEmpty {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
//                        viewModel.action(.addButtonTapped)
                    } label: {
                        Image(systemName: "plus")
                            .foregroundStyle(Color.primary)
                    }
                }
            }
        }
        .navigationTitle("")
//        .navigationDestination(isPresented: $viewModel.output.showAddHabitView) {
//            UpdateHabitView(type: .add)
//        }
//        .navigationDestination(isPresented: $viewModel.output.showDetailView.1) {
//            HabitDetailView(homeVM: viewModel, habit: $viewModel.output.showDetailView.0)
//        }
        .onAppear {
            viewModel.action(.viewOnAppear)
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
//                viewModel.action(.addButtonTapped)
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

//#Preview {
//    NavigationView {
//        HomeView()
//    }
//}
