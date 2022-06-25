//
//  MyMemojiViewModel.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/05/04.
//

import SwiftUI

class MyMemojiViewModel: ObservableObject {
    @AppStorage(AppStorageKey.cardList.string) private var cardInfoList: Data = Data()
    
    @Published private var firstMemojiCard: MemojiCard?
    @Published private var SecondMemojiCard: MemojiCard?
    
    @ViewBuilder
    func goToMemojiView(memojiCard: MemojiCard?, isFirst: Bool) -> some View {
        if let memojiCard = memojiCard {
            MemojiCardView(memojiCard: memojiCard, preImageData: memojiCard.imageData)
        } else {
            NavigationLink(destination: MakeMemojiCardView(isFirst: isFirst)) {
                MakeCardView()
            }
        }
    }
    
    @ViewBuilder
    func setMyMemojiCard() -> some View {
        HStack {
            self.goToMemojiView(memojiCard: self.firstMemojiCard, isFirst: true)
            self.goToMemojiView(memojiCard: self.SecondMemojiCard, isFirst: false)
        }
    }
    
    func findMemojiCard() {
        let memojiCardList = JsonManager.shared.jsonDecoder(decodingData: self.cardInfoList).filter {
            $0.isMyCard
        }
        self.firstMemojiCard = nil
        self.SecondMemojiCard = nil
        for memojiCard in memojiCardList{
            if memojiCard.isFirst {
                self.firstMemojiCard = memojiCard
            } else {
                self.SecondMemojiCard = memojiCard
            }
        }
    }
}
