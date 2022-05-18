
//
//  ContentView.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/04/27.
//

import SwiftUI

class GroupFilter: ObservableObject {
    var groupListData: Data {
        get{
            @AppStorage(AppStorageKey.groupList.string) var groupListData: Data = Data()
            return groupListData
        }
        set {
            @AppStorage(AppStorageKey.groupList.string) var groupListData: Data = Data()
            groupListData = newValue
        }
    }
    
//    @Published var selectedGroupList: [Group] = []
}

struct ContentView: View {
//    @EnvironmentObject var groupFilter: GroupFilter
    @StateObject private var groupFilter: GroupFilter = GroupFilter()
    @State private var selectedGroupList: [Group] = []
    @State private var searchText = ""
    @State private var isShowMyPage = false
    @AppStorage(AppStorageKey.firstUser.string) private var firstUser: Bool = true
//    @StateObject var groupFilter: GroupFilter = GroupFilter()
    
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
                    GridCardView(groupFilter: self.groupFilter, selectedGroupList: self.$selectedGroupList, searchText: self.$searchText)
//                    GridCardView(groupFilter: self.groupFilter, searchText: self.$searchText)
                    //, selectedGroupList: self.$groupFilter.selectedGroupList, searchText: self.$searchText)
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
                    FilterGroupView(groupFilter: self.groupFilter, selectedGroupList: self.$selectedGroupList)
//                    FilterGroupView(groupFilter: self.groupFilter)
                    //selectedGroupList: self.$groupFilter.selectedGroupList)
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
