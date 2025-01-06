//
//  ContentView.swift
//  HappBit
//
//  Created by 아라 on 9/18/24.
//

import SwiftUI

struct ContentView: View {
    @State private var tag = 0
    
    var body: some View {
        TabView(selection: $tag) {
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Image(systemName: "house")
            }
            .tag(0)
            
            NavigationStack {
                EstablishedView()
            }
            .tabItem {
                Image(systemName: "heart.fill")
            }
            .tag(1)
            
            NavigationView {
                PauseListView()
            }
            .tabItem {
                Image(systemName: "archivebox")
            }
            .tag(2)
        }
        .accentColor(.primary)
    }
}

#Preview {
    ContentView()
}
