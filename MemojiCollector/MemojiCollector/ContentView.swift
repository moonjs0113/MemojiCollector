
//
//  ContentView.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/04/27.
//

import SwiftUI

struct ContentView: View {
    var gridItems = [GridItem(.flexible()), GridItem(.flexible()),]
    
    var sessionArray = ["All", "Morning", "Afternoon"]
    @State private var session = "All"
    @State private var searchText = ""
    @State private var isShowMyPage = false
    
    @AppStorage(AppStorageKey.cardList.string) private var cardInfoList: Data = Data()
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
                            let memojiList = JsonManager.shared.jsonDecoder(decodingData: self.cardInfoList).filter {
                                !$0.isMyCard
                            }.filter{ memoji in
                                if self.session == "All" { return true }
                                else {
                                    return memoji.session == self.session
                                }
                            }.filter { memoji in
                                print(memoji.imageData)
                                if self.searchText == "" { return true }
                                else { return memoji.name.lowercased().contains(self.searchText) || memoji.name.uppercased().contains(self.searchText) }
                            }
                            ForEach(memojiList, id: \.self) { memoji in
                                NavigationLink(destination: MemojiDetailView(memojiCard: memoji)) {
                                    MemojiCardView(memojiCard: memoji, preImageData: memoji.imageData)
                                }
                                .disabled(memoji.imageData.count == 0)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
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
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.black)
                                .background {
                                    Circle()
                                        .fill(Color("MainColor"))
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

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
