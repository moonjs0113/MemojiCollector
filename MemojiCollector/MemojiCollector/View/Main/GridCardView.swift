//
//  GridCardView.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/05/03.
//

import SwiftUI

struct GridCardView: View {    
    let gridItems: [GridItem] = [GridItem(.flexible()), GridItem(.flexible()),]
    @AppStorage(AppStorageKey.cardList.string) var cardInfoList: Data = Data()
        @AppStorage(AppStorageKey.groupList.string) private var groupListData: Data = Data()
    
    @StateObject var groupFilter: GroupFilter
    @Binding var selectedGroupList: [Group]
    @Binding var searchText: String
    
    func updateSelectedGroupList() {
        let groupList = JsonManager.shared.jsonToGroupDecoder(decodingData: self.groupListData)
        //        for (index,selectedgroup) in self.groupFilter.selectedGroupList.enumerated() {
        for (index,selectedgroup) in self.selectedGroupList.enumerated() {
            if !groupList.map({$0.name}).contains(selectedgroup.name) {
                //                self.groupFilter.selectedGroupList.remove(at: index)
                self.selectedGroupList.removeAll{ $0.name == selectedgroup.name}
            } else {
//                for group in groupList {
//                    if group.id == selectedgroup.id && group.name != selectedgroup.name {
//                        //                        self.groupFilter.selectedGroupList[index].name = group.name
//                        self.selectedGroupList[index].name = group.name
//                    }
//                }
            }
        }
    }
    
    func filterList() -> [MemojiCard] {
        let filteredList = JsonManager.shared.jsonDecoder(decodingData: self.cardInfoList).sorted {
            $0.name < $1.name
        }.filter {
            !$0.isMyCard
        }.filter { memoji in
            if self.searchText == "" { return true }
            else { return memoji.name.lowercased().contains(self.searchText) || memoji.name.uppercased().contains(self.searchText) }
        }
        
        self.updateSelectedGroupList()
//        if self.groupFilter.selectedGroupList.isEmpty {
        if self.selectedGroupList.isEmpty {
            return filteredList
        } else {
            var groupedList: [MemojiCard] = []
            filteredList.forEach{ memoji in
                if !groupedList.contains(memoji) {
//                    for group in self.groupFilter.selectedGroupList {
                    for group in self.selectedGroupList {
                        if group.memojiCardList.map({$0.urlString}).contains(memoji.urlString) {
                            groupedList.append(memoji)
                        }
                    }
                }
            }
            
            return groupedList
        }
    }
    
    var body: some View {
        ScrollView {
            Spacer()
            LazyVGrid(columns: self.gridItems) {
                let memojiList = self.filterList()
                ForEach(Array(memojiList.enumerated()), id: \.1.urlString) { index, memoji in
                    MemojiCardView(memojiCard: memoji, preImageData: memoji.imageData)
                    if index == 0 {
                        if memojiList.count == 1 {
                            EmptyCardView(memojiCard: memoji)
                        } else if memoji.token != memojiList[index + 1].token {
                            EmptyCardView(memojiCard: memoji)
                        }
                    } else if index == memojiList.count - 1 {
                        if memoji.token != memojiList[index - 1].token {
                            EmptyCardView(memojiCard: memoji)
                        }
                    } else {
                        if memoji.token != memojiList[index + 1].token {
                            if memoji.token != memojiList[index - 1].token {
                                EmptyCardView(memojiCard: memoji)
                            }
                        }
                    }
                }
                Spacer(minLength: 110)
            }
            .padding(.horizontal, 20)
            Spacer()
        }
    }
}

//struct GridCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        GridCardView(session: "Morning", searchText: "")
//    }
//}
