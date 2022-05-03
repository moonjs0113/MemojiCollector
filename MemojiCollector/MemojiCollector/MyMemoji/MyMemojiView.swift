//
//  MyMemojiView.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/04/27.
//

import SwiftUI

struct MyMemojiView: View {
    @AppStorage(AppStorageKey.userName.string) private var userName = ""
    @AppStorage(AppStorageKey.userSession.string) private var userSession = "Morning"
    @AppStorage(AppStorageKey.cardList.string) private var cardInfoList: Data = Data()
//    @AppStorage(AppStorageKey.myCardInfo.string) private var myCardInfoList: Data = Data()
    
    @State private var firstMemojiCard: MemojiCard?
    @State private var SecondMemojiCard: MemojiCard?
    
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
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 100) {
                Text("내 미모지")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(alignment: .leading)
                    .padding(.leading, 20)
                HStack {
                    self.goToMemojiView(memojiCard: self.firstMemojiCard, isFirst: true)
                    self.goToMemojiView(memojiCard: self.SecondMemojiCard, isFirst: false)
                }
                .padding(.horizontal, 20)
                Spacer()
            }
            .onAppear {
                self.findMemojiCard()
            }
        }
    }
}

struct MyMemojiView_Previews: PreviewProvider {
    static var previews: some View {
        MyMemojiView()
    }
}
