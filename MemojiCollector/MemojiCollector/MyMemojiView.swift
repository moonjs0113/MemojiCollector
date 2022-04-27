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
    
    @AppStorage(AppStorageKey.firstCard.string) private var firstCardInfo = ""
    @AppStorage(AppStorageKey.secondCard.string) private var secondCardInfo = ""
    
    @ViewBuilder
    func goToMemojiView(key: String, index: Int) -> some View{
        if key == "" {
            NavigationLink("미모지 만들기", destination: MakeMemojiCardView(index: index))
        } else {
            MemojiCardView(isFirst: (index == 0))
        }
    }
    
    @State private var countInfo: Int = 0
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20){
                VStack{
                    Text("닉네임: \(self.userName)")
                    Text("세션: \(self.userSession)")
                }
                HStack {
                    self.goToMemojiView(key: self.firstCardInfo, index: 0)
                    self.goToMemojiView(key: self.secondCardInfo, index: 1)
                }
                
                Text("\(self.countInfo)/2")
            }
            .onAppear {
                var count = 0
                if self.firstCardInfo != "" { count += 1 }
                if self.secondCardInfo != "" { count += 1 }
                self.countInfo = count
            }
        }
    }
}

struct MyMemojiView_Previews: PreviewProvider {
    static var previews: some View {
        MyMemojiView()
    }
}
