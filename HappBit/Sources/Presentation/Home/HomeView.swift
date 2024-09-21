//
//  HomeView.swift
//  HappBit
//
//  Created by 아라 on 9/21/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                HabitCardView()
            }
            .navigationTitle("HappBit")
            .background(Color.hbSecondary)
            .shadow(color: .gray.opacity(0.15), radius: 10)
        }
    }
}

#Preview {
    HomeView()
}
