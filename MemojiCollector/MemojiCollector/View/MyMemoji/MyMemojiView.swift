//
//  MyMemojiView.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/04/27.
//

import SwiftUI

struct MyMemojiView: View {
    @StateObject var viewModel: MyMemojiViewModel = MyMemojiViewModel()

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 100) {
                Text("내 미모지")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(alignment: .leading)
                    .padding(.leading, 20)
                MemojiCardHStack()
                .padding(.horizontal, 20)
                Spacer()
            }
        }
    }
}


// MARK: - ViewBuilder
extension MyMemojiView {
    @ViewBuilder
    func MemojiCard(memojiCardID: String, isRight: Bool) -> some View {
        if !memojiCardID.isEmpty {
            MemojiCardView(cardID: memojiCardID, isRight: isRight)
        } else {
            NavigationLink(destination: MakeMemojiCardView(isRight: isRight)) {
                MakeCardView()
            }
        }
    }
    
    @ViewBuilder
    func MemojiCardHStack() -> some View {
        HStack {
            self.MemojiCard(memojiCardID: viewModel.leftCardID, isRight: false)
            self.MemojiCard(memojiCardID: viewModel.rightCardID, isRight: true)
        }
    }
}

// MARK: - PreviewProvider
struct MyMemojiView_Previews: PreviewProvider {
    static var previews: some View {
        MyMemojiView()
    }
}
