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
            
            NavigationLink(destination: MemojiDetailView(memojiCard: memojiCard)) {
                MemojiCardView(memojiCard: memojiCard)
            }
        } else {
            NavigationLink(destination: MakeMemojiCardView(isFirst: isFirst)) {
                EmptyCardView()
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
            VStack(alignment: .leading, spacing: 20){
                Text("\(self.userName)")
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(alignment: .leading)
                    .padding(.leading, 20)
                
                HStack {
                    self.goToMemojiView(memojiCard: self.firstMemojiCard, isFirst: true)
                    self.goToMemojiView(memojiCard: self.SecondMemojiCard, isFirst: false)
                }
                .padding(.horizontal, 20)
//                VStack{
//
//                    Text("세션: \(self.userSession)")
//                }
            }
            .onAppear {
                self.findMemojiCard()
            }
        }
    }
}

struct EmptyCardView: View {
    let buttonSize: CGFloat = 60
    
    var body: some View {
        ZStack {
            Color("MainColor").opacity(0.1)
                .cornerRadius(20)
            Circle()
                .fill(Color("MainColor"))
                .frame(width: self.buttonSize, height: self.buttonSize)
            Image(systemName: "plus")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .tint(.white)
                .frame(width: self.buttonSize - 15, height: self.buttonSize - 15)
        }
        .frame(minWidth: 50, maxWidth: .infinity, minHeight: 50, maxHeight: .infinity)
        .aspectRatio(11/17, contentMode: .fit)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(lineWidth: 1)
                .foregroundColor(Color(red: 200/255, green: 200/255, blue: 200/255)))
        
    }
}

struct MyMemojiView_Previews: PreviewProvider {
    static var previews: some View {
        MyMemojiView()
    }
}
