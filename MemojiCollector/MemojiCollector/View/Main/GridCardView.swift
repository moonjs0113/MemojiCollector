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
    @Binding var searchText: String
    
    
    func isContainSearchKeyword(memoji: MemojiCard) -> Bool {
        let inName = memoji.name.lowercased().contains(self.searchText) || memoji.name.uppercased().contains(self.searchText)
        let inSubTitle = memoji.subTitle.lowercased().contains(self.searchText) || memoji.subTitle.uppercased().contains(self.searchText)
        return inName || inSubTitle
    }
    
    func filterList() -> [MemojiCard] {
        let filteredList = JsonManager.shared.jsonDecoder(decodingData: self.cardInfoList).sorted {
            $0.name < $1.name
        }.filter {
            !$0.isMyCard
        }.filter { memoji in
            if self.searchText == "" { return true }
            else { return self.isContainSearchKeyword(memoji: memoji) }
        }
        return filteredList
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
