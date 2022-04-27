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
    
    @State private var isShowMyPage = false
    
    @AppStorage(AppStorageKey.firstUser.string) private var firstUser: Bool = true
    
    @ViewBuilder
    func goToMyMemojiView() -> some View{
        if self.firstUser {
            RegisterUserView(isShowMyPage: self.$isShowMyPage)
        } else {
            MyMemojiView()
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
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
                                NavigationLink("Grid \(number)", destination: MemojiDetailView())
                            }
                        }
                    }
                    Spacer()
                }
                
                VStack{
                    Spacer()
                    HStack{
                        Spacer()
                        Button{
                            self.isShowMyPage.toggle()
                            print("button")
                        } label: {
                            Image(systemName: "person.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.black)
                                .background {
                                    Circle()
                                        .fill(Color(red: 66/255, green: 234/255, blue: 221/255))
                                        .frame(width: 60, height: 60)
                                }
                        }
                        .padding([.bottom, .trailing], 50)
                        .sheet(isPresented: self.$isShowMyPage) {
                            self.goToMyMemojiView()
                        }
                    }
                }
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
