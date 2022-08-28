//
//  MyMemojiViewModel.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/05/04.
//

import SwiftUI

class MyMemojiViewModel: ObservableObject {
    @AppStorage(AppStorageKey.cardList.string) private var cardInfoList: Data = Data()
    @AppStorage("LEFT_CARD_ID") var leftCardID = ""
    @AppStorage("RIGHT_CARD_ID") var rightCardID = ""
    
    @Published var firstMemojiCard: MemojiCard?
    @Published var secondMemojiCard: MemojiCard?
    
    func findMemojiCard() {
        let memojiCardList = JsonManagerClass.shared.jsonDecoder(decodingData: self.cardInfoList).filter {
            $0.isMyCard
        }
        self.firstMemojiCard = nil
        self.secondMemojiCard = nil
        for memojiCard in memojiCardList{
            if memojiCard.isFirst {
                self.firstMemojiCard = memojiCard
            } else {
                self.secondMemojiCard = memojiCard
            }
        }
    }
}
