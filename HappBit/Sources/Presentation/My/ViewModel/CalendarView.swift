//
//  CalendarView.swift
//  HappBit
//
//  Created by 아라 on 3/19/25.
//

import SwiftUI

struct CalendarView: View {
    @State var date: Date
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
                    changeMonth(by: 1)
                  } else if gesture.translation.width > 100 {
                    changeMonth(by: -1)
                  }
                  self.offset = CGSize()
                }
            )
    }
    
    private func headerView() -> some View {
        VStack {
            HStack {
                Button {
                    changeMonth(by: -1)
                } label: {
                    Image(systemName: "chevron.backward")
                        .foregroundStyle(.gray)
                        .fontWeight(.black)
                }
                
                Spacer()
                
                Text(date.toString(.header))
                    .font(.sub)
                
                Spacer()
                
                Button {
                    changeMonth(by: 1)
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
        let daysInMonth: Int = numberOfDays(in: date)
        let firstWeekday: Int = firstWeekdayOfMonth(in: date) - 1
        
        return VStack {
            LazyVGrid(columns: Array(repeating: GridItem(spacing: 0), count: 7)) {
                ForEach(0 ..< daysInMonth + firstWeekday, id: \.self) { index in
                    if index < firstWeekday {
                        Rectangle()
                            .foregroundColor(Color.clear)
                    } else {
                        let day = index - firstWeekday + 1
                        
                        DayCellView(day: day)
                    }
                }
            }
        }
    }
}

struct DayCellView: View {
    let day: Int
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("\(day)")
                .font(.body2M)
            recordView(.uncomplete)
            
            Spacer()
        }
    }
    
    private func recordView(_ type: RecordType) -> some View {
        Group {
            switch type {
            case .consecutive:
                Rectangle()
                    .frame(height: 8)
                    .foregroundStyle(Color.hapRed)
                    .opacity(1)
            case .single:
                Circle()
                    .frame(width: 8)
                    .foregroundStyle(Color.hapRed)
                    .opacity(1)
            case .uncomplete:
                Rectangle()
                    .frame(height: 8)
                    .foregroundStyle(.clear)
            }
        }
    }
}

private extension CalendarView {
    func startOfMonth() -> Date {
        let components = Calendar.current.dateComponents([.year, .month], from: date)
        return Calendar.current.date(from: components)!
    }
    
    func numberOfDays(in date: Date) -> Int {
        return Calendar.current.range(of: .day, in: .month, for: date)?.count ?? 0
    }
    
    func firstWeekdayOfMonth(in date: Date) -> Int {
        let components = Calendar.current.dateComponents([.year, .month], from: date)
        let firstDayOfMonth = Calendar.current.date(from: components)!
        
        return Calendar.current.component(.weekday, from: firstDayOfMonth)
    }
    
    func changeMonth(by value: Int) {
        let calendar = Calendar.current
        if let newMonth = calendar.date(byAdding: .month, value: value, to: date) {
            self.date = newMonth
        }
    }
}

#Preview {
    CalendarView(date: Date())
}

enum RecordType {
    case consecutive
    case single
    case uncomplete
}
