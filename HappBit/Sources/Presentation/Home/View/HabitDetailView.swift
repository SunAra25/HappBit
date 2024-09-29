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
    @StateObject var viewModel = HabitDetailViewModel()
    @ObservedObject var homeVM: HomeViewModel
    @Binding var habit: Habit
    @Environment(\.dismiss) private var dismiss
    let colorList = [Color.hapRed, Color.hapYellow, Color.hapGreen, Color.hapMint, Color.hapBlue, Color.hapPurple]
    
    var body: some View {
        ScrollView {
            Text(viewModel.output.data.title)
                .font(.head)
            
            HStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(colorList[viewModel.output.data.colorIndex].opacity(0.15))
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
            Menu {
                Button {
                    viewModel.action(.editBtnDidTap)
                } label: {
                    Text("수정")
                }
                
                Button {
                    viewModel.action(.pauseBtnDidTap)
                } label: {
                    Text("중지")
                }
                
                Button {
                    viewModel.action(.deleteBtnDidTap)
                } label: {
                    Text("삭제")
                }
            } label: {
                Image(systemName: "ellipsis")
            }
        }
        .alert(Text("[\(viewModel.output.data.title)] 중지"), isPresented: $viewModel.output.showPauseAlert, actions: {
            Button("확인") {
                viewModel.action(.pauseAgreeBtnDidTap(habit: viewModel.output.data))
                habit = viewModel.output.data
                dismiss()
            }
            Button("취소", role: .cancel) {}
        }, message: {
            Text("습관 보관함으로 이동합니다.")
        })
        .alert(Text("[\(viewModel.output.data.title)] 삭제"), isPresented: $viewModel.output.showDeleteAlert, actions: {
            Button("확인", role: .destructive) {
                viewModel.action(.deleteAgreeBtnDidTap(habit: viewModel.output.data))
//                homeVM.action(.viewOnAppear)
                dismiss()
            }
            Button("취소", role: .cancel) {}
        }, message: {
            Text("습관 실천 기록이 모두 지워집니다.")
        })

        .navigationTitle("")
        .navigationDestination(isPresented: $viewModel.output.showEditHabitView) {
            UpdateHabitView(type: .edit(habit: viewModel.output.data))
        }
        .onAppear {
            viewModel.action(.viewOnAppear(habit: habit))
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
                Text("\(viewModel.output.data.practiceDates.count)")
                    .font(.head)
            case .sequence:
                Text("\(viewModel.output.data.consecutiveDays)")
                    .font(.head)
            case .clover:
                Text("\(viewModel.output.data.consecutiveDays / 3)")
                    .font(.head)
            }
        }
    }
}

//#Preview {
//    NavigationView {
//        HabitDetailView()
//    }
//}
