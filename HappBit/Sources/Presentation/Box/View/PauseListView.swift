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
            Text("잠시 실천 중지한 습관 모음 ☘️")
                .asSubTitle()
            
            if viewModel.output.habitList.isEmpty {
                EmptyPauseView()
            } else {
                ScrollView {
                    ForEach(viewModel.output.habitList, id: \.id) { habit in
                        PauseCardView(listVM: viewModel, habit: habit)
                    }
                }
            }
        }
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

//#Preview {
//    PauseListView()
//}
