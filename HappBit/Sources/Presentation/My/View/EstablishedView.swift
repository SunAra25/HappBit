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
            if viewModel.output.habitList.isEmpty {
                EmptyEstablishedView()
            } else {
                ExistEstablishedView(viewModel: viewModel)
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
            Text("66일간의 습관 실천을 통해 내 습관으로 만들어보세요☘️")
                .font(.body2M)
                .foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.hbSecondary)
    }
}

struct ExistEstablishedView: View {
    @ObservedObject var viewModel: EstablishedViewModel
    
    var body: some View {
        ScrollView {
            HStack {
                ForEach(ActionDays.allCases, id: \.self) { type in
                    ActionDaysCardView(habitList: viewModel.output.habitList, type: type)
                }
            }
            .padding(.top)
            .padding(.horizontal)
            
            VStack {
                Text("자리잡은 습관")
                    .font(.body1B)
                    .foregroundStyle(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                ForEach(viewModel.output.habitList, id: \.0.id) { values in
                    rowView(values.0)
                }
            }.padding()
        }
        .background(Color.hbSecondary)
    }
    
    func rowView(_ habit: Habit) -> some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.hbThirdary)
            .frame(height: 56)
            .overlay {
                HStack {
                    Text(habit.title)
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
    let habitList: [(Habit, PracticeStatus)]
    let type: ActionDays
    
    var body: some View {
        GeometryReader { geometry in
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.hbQuarterly)
                .frame(height: geometry.size.width)
                .overlay {
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
                Text(habitList.count.formatted())
                    .font(.head)
                    .foregroundStyle(Color.hbPrimary)
                
                Text("개의")
            }
            .padding(.bottom, 1)
            
            Text("습관이 자리잡았어요")
        }
        .font(.body2B)
        .foregroundStyle(Color.hbSecondary)
    }
    
    var dateCountView: some View {
        VStack {
            HStack(alignment: .bottom) {
                Text("총")
                
                Text("\(habitList.reduce(0) { $0 + $1.1.practiceDates.count }.formatted() )")
                    .font(.head)
                    .padding(.horizontal, -5)
                    .foregroundStyle(Color.hbPrimary)
                
                Text("일")
            }
            .padding(.bottom, 1)
            
            Text("실천하셨어요")
        }
        .font(.body2B)
        .foregroundStyle(Color.hbSecondary)
    }
}

enum ActionDays: CaseIterable {
    case clover
    case date
}

#Preview {
    EstablishedView()
}
