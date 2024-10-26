//
//  PauseCardView.swift
//  HappBit
//
//  Created by 아라 on 10/23/24.
//

import SwiftUI

struct PauseCardView: View {
    @StateObject private var viewModel = PauseCardViewModel()
    @StateObject var listVM: PauseListViewModel
    let habit: HabitEntity
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.hbThirdary)
            
            menuView()
            
            VStack {
                Text(habit.title ?? "")
                    .font(.sub)
                
                Text(viewModel.output.lastConsecutiveDate)
                    .font(.body2M)
                    .foregroundStyle(.gray)
                    .padding(.vertical, 4)
                
                HStack {
                    Text("☘️ \(viewModel.output.cloverCount)개")
                        .padding(8)
                        .overlay {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.gray.opacity(0.1))
                        }
                    
                    Text("실천 \(viewModel.output.countConsecutiveDays)일")
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
        .alert(Text("[\(habit.title ?? "")] 삭제"), isPresented: $listVM.output.showDeleteAlert, actions: {
            Button("확인", role: .destructive) {
                listVM.action(.deleteAgreeBtnDidTap(habit: habit))
            }
            Button("취소", role: .cancel) {}
        }, message: {
            Text("습관 실천 기록이 모두 지워집니다.")
        })
        .onAppear {
            viewModel.action(.viewOnAppear(habit: habit))
        }
    }
    
    func menuView() -> some View {
        Menu {
            Button {
                listVM.action(.restartBtnDidTap(habit: habit))
            } label: {
                Text("다시 시작")
            }
            
            Button {
                listVM.action(.deleteBtnDidTap)
            } label: {
                Text("삭제")
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
