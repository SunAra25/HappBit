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
    @StateObject var  viewModel = HabitDetailViewModel()
    @Binding var habit: Habit
    @Binding var status: PracticeStatus
    @Environment(\.dismiss) private var dismiss
    let colorList = [Color.hapRed, Color.hapYellow, Color.hapGreen, Color.hapMint, Color.hapBlue, Color.hapPurple]
    
    var body: some View {
        ScrollView {
            Text(viewModel.output.data.0.title)
                .font(.head)
            
            HStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(colorList[viewModel.output.data.0.color].opacity(0.15))
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
                    viewModel.action(.editBtnDidTap(habit: viewModel.output.data.0))
                } label: {
                    Text("수정")
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
        .alert(Text("☘️\(viewModel.output.data.0.title)☘️ 삭제"), isPresented: $viewModel.output.showDeleteAlert, actions: {
            Button("삭제", role: .destructive) {
                viewModel.action(.deleteAgreeBtnDidTap(habit: viewModel.output.data.0, status: viewModel.output.data.1))
                dismiss()
            }
            Button("취소", role: .cancel) {}
        }, message: {
            Text("습관 실천 기록이 모두 지워집니다.")
        })
        .onAppear {
            viewModel.action(.viewOnAppear(habit: habit, status: status))
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
                Text("\(viewModel.output.data.1.practiceDates.count)")
                    .font(.head)
            case .sequence:
                Text("\(viewModel.output.data.1.consecutiveDays)")
                    .font(.head)
            case .clover:
                Text("\(viewModel.output.data.1.consecutiveDays / 3)")
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
