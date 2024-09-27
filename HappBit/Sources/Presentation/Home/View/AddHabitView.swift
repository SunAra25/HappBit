//
//  AddHabitView.swift
//  HappBit
//
//  Created by 아라 on 9/22/24.
//

import SwiftUI

struct AddHabitView: View {
    @StateObject var viewModel = AddHabitViewModel()
    @State private var titleInput = ""
    @State private var selectedColor: Color?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("습관 추가하기")
                .font(.head)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 8)
            
            Text("습관 이름")
                .font(.body1B)
                .foregroundStyle(.gray)
            
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.hbThirdary)
                .frame(height: 60)
                .overlay {
                    TextField("title", text: Binding(
                        get: { viewModel.output.currentTitle },
                        set: { viewModel.action(.editingTitle(text: ($0))) } ),
                        prompt: Text("어떤 습관을 형성해볼까요?"))
                        .font(.body1M)
                        .padding(.horizontal)
                        .tint(.primary)
                    
                    Text("\(titleInput.count)/15")
                        .font(.body2M)
                        .foregroundStyle(.gray)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding()
                }
                .padding(.bottom)
            
            Text("습관 색상")
                .font(.body1B)
                .foregroundStyle(.gray)
            
            ColorPickerView(viewModel: viewModel)
            
            Spacer()
            
            Button {
                viewModel.action(.addHabit)
                dismiss()
            } label: {
                RoundedRectangle(cornerRadius: 12)
                    .fill(viewModel.output.buttonState ? Color.primary : .gray.opacity(0.3))
                    .frame(height: 56)
                    .frame(maxWidth: .infinity)
                    .overlay {
                        Text("확인")
                            .foregroundStyle(viewModel.output.buttonState ? Color.hbPrimary : .gray.opacity(0.8))
                            .font(.body1B)
                    }
            }
        }
        .padding()
        .background(Color.hbSecondary)
    }
}

private struct ColorPickerView: View {
    @ObservedObject var viewModel: AddHabitViewModel
    var colorList = [Color.hapRed, Color.hapYellow, Color.hapGreen, Color.hapMint, Color.hapBlue, Color.hapPurple]
    
    var body: some View {
        HStack {
            ForEach(colorList, id: \.self) { color in
                Button {
                    viewModel.action(.selectedColor(index: colorList.firstIndex(of: color)!))
                } label: {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(color)
                        .frame(height: 40)
                        .overlay {
                            if let index = colorList.firstIndex(of: color),
                               index == viewModel.output.currentColorIndex {
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(.white)
                                    .padding(2.5)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 6)
                                            .fill(color)
                                            .padding(4)
                                            .overlay {
                                                Image(systemName: "checkmark")
                                                    .tint(.white)
                                                    .font(.body1B)
                                            }
                                    }
                            }
                        }
                }
            }
        }
    }
}
#Preview {
    NavigationView {
        AddHabitView()
    }
}
