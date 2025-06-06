//
//  MyHabitView.swift
//  HappBit
//
//  Created by 아라 on 9/27/24.
//

import SwiftUI

struct EstablishedView: View {
    @StateObject private var viewModel = EstablishedViewModel()
    
    var body: some View {
        VStack {
            Text("내 습관 현황 ☘️")
                .asSubTitle()
            
            if viewModel.output.habitList.isEmpty {
                Spacer()
                EmptyEstablishedView()
                Spacer()
            } else {
                ExistEstablishedView(viewModel: viewModel)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.hbSecondary)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Text("happbit")
                    .font(.head)
            }
        }
        .onAppear {
            viewModel.action(.viewOnAppear)
        }
    }
}

struct EmptyEstablishedView: View {
    var body: some View {
        VStack {
            Text("아직 자리잡은 습관이 없어요!")
                .font(.head)
                .padding()
            Text("66일간의 습관 실천을 통해 내 습관으로 만들어보세요 ☘️")
                .font(.body2M)
                .foregroundStyle(.gray)
        }
    }
}

struct ExistEstablishedView: View {
    @ObservedObject var viewModel: EstablishedViewModel
    
    var body: some View {
        ScrollView {
            HStack {
                ForEach(ActionDays.allCases, id: \.self) { type in
                    ActionDaysCardView(viewModel: viewModel, type: type)
                }
            }
            .padding(.top)
            .padding(.horizontal)
            
            VStack {
                Text("자리잡은 습관")
                    .font(.body1B)
                    .foregroundStyle(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                ForEach(viewModel.output.habitList, id: \.id) { habit in
                    Button {
                        viewModel.action(.rowDidTap(habit))
                    } label: {
                        rowView(habit)
                    }
                }
            }.padding()
        }
        .navigationTitle("")
        .navigationDestination(isPresented: $viewModel.output.showDetailView) {
            EstablishedDetailView(habitID: viewModel.output.detailHabit?.objectID)
        }
    }
    
    func rowView(_ habit: HabitEntity) -> some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.hbThirdary)
            .frame(height: 56)
            .overlay {
                HStack {
                    Text(habit.title ?? "")
                        .font(.body1M)
                    
                    Spacer()
                    
                    Image(systemName: "arrow.right")
                        .foregroundStyle(.gray)
                }
                .padding()
            }
    }
}

struct ActionDaysCardView: View {
    @ObservedObject var viewModel: EstablishedViewModel
    let type: ActionDays
    
    var body: some View {
        GeometryReader { geometry in
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.hbThirdary)
                .frame(height: geometry.size.width)
                .shadow(color: .gray.opacity(0.15), radius: 10)
                .overlay {
                    Image("Clover")
                        .resizable()
                        .scaledToFit()
                    switch type {
                    case .clover: cloverCountView
                    case .date: dateCountView
                    }
                }
                
        }
        .aspectRatio(1, contentMode: .fit)
    }
    
    var cloverCountView: some View {
        VStack {
            HStack(alignment: .bottom) {
                Text(viewModel.output.habitList.count.formatted())
                    .font(.head)
                    .foregroundStyle(Color.primary)
                
                Text("개의")
            }
            .padding(.bottom, 1)
            
            Text("습관이 자리잡았어요")
        }
        .font(.body2B)
        .foregroundStyle(Color.primary.opacity(0.7))
    }
    
    var dateCountView: some View {
        VStack {
            HStack(alignment: .bottom) {
                Text("총")
                
                Text("\(viewModel.output.consecutiveDays)")
                    .font(.head)
                    .padding(.horizontal, -5)
                    .foregroundStyle(Color.primary)
                
                Text("일")
            }
            .padding(.bottom, 1)
            
            Text("실천하셨어요")
        }
        .font(.body2B)
        .foregroundStyle(Color.primary.opacity(0.7))
    }
}

enum ActionDays: CaseIterable {
    case clover
    case date
}

//#Preview {
//    EstablishedView()
//}
