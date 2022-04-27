//
//  ContentView.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/04/27.
//

import SwiftUI

struct ContentView: View {
    @State private var sessionArray = ["All", "Morning", "Afternoon"]
    private var gridItems = [GridItem(.flexible()), GridItem(.flexible())]
    @State private var session = "All"
    @State private var searchText = ""
    
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("",selection: self.$session) {
                    ForEach(self.sessionArray, id: \.self) { session in
                        Text(session)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                ScrollView {
                    LazyVGrid(columns: self.gridItems){
                        ForEach(0..<100, id: \.self) { number in
                            Text("Grid \(number)")
                        }
                    }
                }
                Spacer()
            }
            .navigationTitle("Memoji Collector")
        }
        .searchable(text: self.$searchText)
        .navigationBarTitleDisplayMode(.large)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
