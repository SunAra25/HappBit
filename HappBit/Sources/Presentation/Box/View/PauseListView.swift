//
//  PauseListView.swift
//  HappBit
//
//  Created by 아라 on 9/28/24.
//

import SwiftUI

struct PauseListView: View {
    @StateObject private var viewModel = PauseListViewModel()
    
    var body: some View {
        VStack {
            if viewModel.output.habitList.isEmpty {
                EmptyPauseView()
            } else {
                ScrollView {
                    ForEach(viewModel.output.habitList, id: \.0.id) { values in
                        PauseCardView(viewModel: viewModel, habit: values.0, status: values.1)
                    }
                }
            }
        }
        .background(Color.hbSecondary)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Text("습관 보관함")
                    .font(.head)
            }
        }
        .onAppear {
            viewModel.action(.viewOnAppear)
        }
    }
}

struct EmptyPauseView: View {
    var body: some View {
        VStack {
            Text("아직 중지한 습관이 없어요!")
                .font(.head)
                .padding()
            Text("이대로 멈추지 않고 습관 실천을 해보아요☘️")
                .font(.body2M)
                .foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.hbSecondary)
    }
}

struct PauseCardView: View {
    let viewModel: PauseListViewModel
    let habit: Habit
    let status: PracticeStatus
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.hbThirdary)
            
            menuView(viewModel)
            
            VStack {
                Text(habit.title)
                    .font(.sub)
                
                Text(habit.createdAt.toString() + "-" + (habit.endDate?.toString() ?? ""))
                    .font(.body2M)
                    .foregroundStyle(.gray)
                    .padding(.vertical, 4)
                
                HStack {
                    Text("☘️ \(status.consecutiveDays / 3)개")
                        .padding(8)
                        .overlay {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.gray.opacity(0.1))
                        }
                    
                    Text("실천 \(status.practiceDates.count)일")
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
    
    func menuView(_ viewModel: PauseListViewModel) -> some View {
        Menu {
            Button {
                viewModel.action(.restartBtnDidTap(habit: habit))
            } label: {
                Text("다시 시작")
            }
        } label: {
            Image(systemName: "ellipsis")
                .padding(20)
                .rotationEffect(.degrees(90))
                .padding(.top, 4)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
    }
}

//#Preview {
//    PauseListView()
//}
