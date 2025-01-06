//
//  EstablishDetailView.swift
//  HappBit
//
//  Created by 아라 on 3/24/25.
//

import SwiftUI
import CoreData

struct EstablishedDetailView: View {
    @StateObject private var viewModel = EstablishedDetailViewModel()
    let habitID: NSManagedObjectID?
    
    var body: some View {
        ScrollView {
            HStack {
                Text(viewModel.output.startDate.toString())
                    .padding(.vertical, 8)
                
                Text("~")
                
                Text(viewModel.output.endDate.toString())
                    .padding(.vertical, 8)
            }
            .font(.body2M)
            .foregroundStyle(.gray)
            
            HStack {
                ForEach(EstablishedCardType.allCases, id: \.self) { type in
                    GeometryReader { geometry in
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.hbQuarterly)
                            .frame(height: geometry.size.width)
                    }
                    .aspectRatio(1, contentMode: .fit)
                    .padding(.horizontal, 4)
                    .overlay {
                        switch type {
                        case .record: recordTextView
                        case .clover: cloverTextView
                        }
                    }
                }
            }
            .padding()
            
            CalendarView(date: Date())
            
            Spacer()
        }
        .onAppear {
            viewModel.action(.viewOnAppear(id: habitID))
        }
        .navigationTitle(viewModel.output.title)
    }
    
    var recordTextView: some View {
        VStack {
            Text("그동안")
            
            HStack(alignment: .bottom) {
                Text(String(viewModel.output.recordDays))
                    .font(.head)
                    .foregroundStyle(Color.hbPrimary)
                
                Text("일")
            }
            .padding(.bottom, 1)
            
            Text("실천했어요")
        }
        .font(.body2B)
        .foregroundStyle(Color.hbPrimary.opacity(0.7))
    }
    
    var cloverTextView: some View {
        VStack {
            HStack(alignment: .bottom) {
                Text(String(viewModel.output.cloverCount))
                    .font(.head)
                    .foregroundStyle(Color.hbPrimary)
                
                Text("개의")
            }
            .padding(.bottom, 1)
            
            Text("클로버를 모았어요☘️")
        }
        .font(.body2B)
        .foregroundStyle(Color.hbPrimary.opacity(0.7))
    }
}

enum EstablishedCardType: CaseIterable {
    case record
    case clover
}

//#Preview {
//    EstablishedDetailView()
//}
