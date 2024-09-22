//
//  AddHabitView.swift
//  HappBit
//
//  Created by 아라 on 9/22/24.
//

import SwiftUI

struct AddHabitView: View {
    @State private var titleInput = ""
    @State private var selectedColor: Color?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("습관 이름")
                .font(.body1B)
                .foregroundStyle(.gray)
            
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.hbThirdary)
                .frame(height: 60)
                .overlay {
                    TextField("title", text: $titleInput, prompt: Text("어떤 습관을 형성해볼까요?"))
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
            
            ColorPickerView(selectedColor: $selectedColor)
            
            
            Spacer()
            
            Button {
                // TODO: Realm 저장
            } label: {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.primary)
                    .frame(height: 56)
                    .frame(maxWidth: .infinity)
                    .overlay {
                        Text("확인")
                            .foregroundStyle(Color.hbPrimary)
                            .font(.body1B)
                    }
            }
        }
        .padding()
        .navigationTitle("새로운 습관")
        .navigationBarBackButtonHidden()
        .background(Color.hbSecondary)
    }
}

private struct ColorPickerView: View {
    @Binding var selectedColor: Color?
    @State private var colorList = [Color.hapRed, Color.hapYellow, Color.hapGreen, Color.hapMint, Color.hapBlue, Color.hapPurple]
    
    var body: some View {
        HStack {
            ForEach(colorList, id: \.self) { color in
                Button {
                    selectedColor = color
                } label: {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(color)
                        .frame(height: 40)
                        .overlay {
                            if color == selectedColor {
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
