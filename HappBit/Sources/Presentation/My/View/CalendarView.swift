//
//  CalendarView.swift
//  HappBit
//
//  Created by 아라 on 3/19/25.
//

import SwiftUI

struct CalendarView: View {
    @ObservedObject var viewModel: EstablishedDetailViewModel
    @State var offset: CGSize = CGSize()
    
    var body: some View {
        VStack {
            headerView()
            monthView()
        }
        .padding(.horizontal)
        .gesture(
              DragGesture()
                .onChanged { gesture in
                  self.offset = gesture.translation
                }
                .onEnded { gesture in
                  if gesture.translation.width < -100 {
                      viewModel.action(.changeMonthBtnDidTap(1))
                  } else if gesture.translation.width > 100 {
                      viewModel.action(.changeMonthBtnDidTap(-1))
                  }
                  self.offset = CGSize()
                }
            )
    }
    
    private func headerView() -> some View {
        VStack {
            HStack {
                Button {
                    viewModel.action(.changeMonthBtnDidTap(-1))
                } label: {
                    Image(systemName: "chevron.backward")
                        .foregroundStyle(.gray)
                        .fontWeight(.black)
                }
                
                Spacer()
                
                Text(viewModel.output.currentMonth.toString(.header))
                    .font(.sub)
                
                Spacer()
                
                Button {
                    viewModel.action(.changeMonthBtnDidTap(1))
                } label: {
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.gray)
                        .fontWeight(.black)
                }
            }
            .padding()
            
            HStack(spacing: 0) {
                ForEach(Array(zip(_DateFormatter.standard.veryShortWeekdaySymbols.indices,
                            _DateFormatter.standard.veryShortWeekdaySymbols)), id: \.0) { (index, symbol) in
                    Text(symbol)
                        .font(.body2B)
                        .foregroundStyle(index == 0 ? .red : .quarterly)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.bottom, 5)
        }
    }
    
    private func changeMonthButton(_ imageName: String) -> some View {
        Button {
            
        } label: {
            Image(systemName: imageName)
                .foregroundStyle(.gray)
                .fontWeight(.black)
        }
    }
    
    private func monthView() -> some View {
        return VStack {
            LazyVGrid(columns: Array(repeating: GridItem(spacing: 0), count: 7)) {
                ForEach(0 ..< viewModel.output.daysInMonth + viewModel.output.firstWeekday, id: \.self) { index in
                    if index < viewModel.output.firstWeekday {
                        Rectangle()
                            .foregroundColor(Color.clear)
                    } else {
                        let day = index - viewModel.output.firstWeekday + 1
                        
                        DayCellView(viewModel: viewModel, day: day)
                    }
                }
            }
        }
    }
}

struct DayCellView: View {
    @ObservedObject var viewModel: EstablishedDetailViewModel
    let day: Int
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("\(day)")
                .font(.body2M)
            recordView(getRecordType(day))
            
            Spacer()
        }
        .onAppear {
            
        }
    }
    
    private func recordView(_ type: RecordType) -> some View {
        Group {
            switch type {
            case .consecutive:
                Rectangle()
                    .frame(height: 8)
                    .foregroundStyle(Color.colorList[viewModel.output.colorIndex])
                    .opacity(1)
            case .single:
                Circle()
                    .frame(width: 8)
                    .foregroundStyle(Color.colorList[viewModel.output.colorIndex])
                    .opacity(1)
            case .uncomplete:
                Rectangle()
                    .frame(height: 8)
                    .foregroundStyle(.clear)
            }
        }
    }
}

enum RecordType {
    case consecutive
    case single
    case uncomplete
}

private extension DayCellView {
    func getRecordType(_ day: Int) -> RecordType {
        let currentMonth = viewModel.output.currentMonth
        let records = viewModel.output.records
        
        guard let currentMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: currentMonth)),
              let date = Calendar.current.date(bySetting: .day, value: day, of: currentMonth),
              let target = records.first(where: { isContains($0, target: date) }) else { return .uncomplete }
        
        return target.count == 1 ? .single : .consecutive
    }
    
    func isContains(_ array: [Date], target: Date) -> Bool {
        return array.contains { date in
            Calendar.current.isDate(date, inSameDayAs: target)
        }
    }
}
