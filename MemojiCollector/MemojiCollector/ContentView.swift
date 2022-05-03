
//
//  ContentView.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/04/27.
//

import SwiftUI

struct ContentView: View {
    var sessionArray = ["All", "Morning", "Afternoon"]
    @State private var session = "All"
    @State private var searchText = ""
    @State private var isShowMyPage = false
    
//    @AppStorage(AppStorageKey.cardList.string) private var cardInfoList: Data = Data()
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
                    
                    GridCardView(session: self.$session, searchText: self.$searchText)
                    Spacer()
                }
                
                VStack{
                    Spacer()
                    HStack{
                        Spacer()
                        Button {
                            self.isShowMyPage.toggle()
                        } label: {
                            Image(systemName: "person.fill")
//                            Image(systemName: "person")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
//                                .foregroundColor(.black)
                                .foregroundColor(.white)
                                .background {
                                    Circle()
                                        .fill(.tint)//Color("MainColor"))
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
            .navigationTitle("Memoji Collector")
            .navigationBarTitleDisplayMode(.large)
        }
        .searchable(text: self.$searchText)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
