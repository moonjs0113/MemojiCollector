
//
//  ContentView.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/04/27.
//

import SwiftUI

struct ContentView: View {
    @State private var searchText = ""
    @State private var isShowMyPage = false
    @State private var isShowGuide = false
    @AppStorage(AppStorageKey.firstUser.string) private var firstUser: Bool = true
    @AppStorage(AppStorageKey.firstGuide.string) private var firstGuide: Bool = true
    
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
                GridCardView(searchText: self.$searchText)
                
                VStack{
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            self.isShowMyPage.toggle()
                        } label: {
                            Image(systemName: "person.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.white)
                                .background {
                                    Circle()
                                        .fill(.tint)
                                        .shadow(color: .gray.opacity(0.5), radius: 3, x: 1, y: 2)
                                        .frame(width: 60, height: 60)
                                }
                        }
                        .padding([.bottom, .trailing], 50)
                        .sheet(isPresented: self.$isShowMyPage) {
                            self.goToMyMemojiView()
                        }
                        .sheet(isPresented: $isShowGuide) {
                            GuideView()
                        }
                        .onAppear {
                            if firstGuide {
                                firstGuide = false
                                isShowGuide.toggle()
                            }
                        }
                    }
                }
            }
            .navigationBarItems(trailing:
                                    HStack {
                Button {
                    self.isShowGuide = true
                } label: {
                    Image(systemName: "questionmark.circle")
                }
                NavigationLink {
                    SettingView()
                } label: {
                    Image(systemName: "gear")
                }
            }
            )
            .navigationTitle("Memoji Collector")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: self.$searchText, placement: .automatic)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
