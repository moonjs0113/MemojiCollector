//
//  DeletedCardView.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/05/03.
//

import SwiftUI

struct DeletedCardView: View {
    var memojiCard: MemojiCard
    @State private var isShowAlert: Bool = false
    
    
    var body: some View {
        Button {
            print(self.memojiCard)
            self.isShowAlert.toggle()
        } label: {
            VStack {
                Text("주인이 삭제한 미모지 카드입니다.")
                Text("터치 시, 카드가 삭제됩니다.")
            }
        }
        .alert("삭제하시겠습니까?", isPresented: self.$isShowAlert) {
            Button("네", role: .none) {
                @AppStorage(AppStorageKey.cardList.string) var cardInfoList: Data = Data()
                var memojiList: [MemojiCard] = JsonManager.shared.jsonDecoder(decodingData: cardInfoList)
                memojiList.removeAll{
                    $0.urlString == self.memojiCard.urlString
                }
                cardInfoList = JsonManager.shared.jsonEncoder(ecodingData: memojiList)
            }
            Button("아니요", role: .cancel) { }
        }
    }
}
