
//
//  ContentView.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/04/27.
//

import SwiftUI

struct ContentView: View {
//    @EnvironmentObject var groupFilter: GroupFilter
//    @State private var selectedGroupList: [Group] = []
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
                    Spacer(minLength: 10)
                    GridCardView(searchText: self.$searchText)
                    Spacer()
                }
                
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
                    }
                }
            }
            .navigationBarItems(trailing:
                                    HStack{
                NavigationLink {
                    SettingView()
                }
            label: {
                Image(systemName: "gear")
            }
                NavigationLink {
                    FilterGroupView()
                }
            label: {
                Image(systemName: "tray")
            }
            }
            )
            .navigationTitle("Memoji Collector")
            .navigationBarTitleDisplayMode(.large)
        }
        .searchable(text: self.$searchText)
        .onAppear {
            print("On Appear?")
            print("On Appear?")
            print("On Appear?")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
