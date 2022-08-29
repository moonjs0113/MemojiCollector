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
    
    @Published var leftMemojiCard: MemojiCard?
    @Published var rightMemojiCard: MemojiCard?
    
    func findMemojiCard() {
        let memojiCardList = JsonManagerClass.shared.jsonDecoder(decodingData: self.cardInfoList).filter {
            $0.isMyCard
        }
        self.leftMemojiCard = nil
        self.rightMemojiCard = nil
        for memojiCard in memojiCardList {
            if memojiCard.isRight {
                self.rightMemojiCard = memojiCard
            } else {
                self.leftMemojiCard = memojiCard
            }
        }
    }
}
