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
            .onAppear {
//                viewModel.findMemojiCard()
//                viewModel.loadMemojiCard()
            }
        }
    }
}


// MARK: - ViewBuilder
extension MyMemojiView {
    @ViewBuilder
//    func MemojiCard(memojiCard: MemojiCard?, isFirst: Bool) -> some View {
    func MemojiCard(memojiCardID: String, isFirst: Bool) -> some View {
        if !memojiCardID.isEmpty {
//            MemojiCardViewLocalData(memojiCard: memojiCard, preImageData: memojiCard.imageData)
            MemojiCardView(cardID: memojiCardID)
        } else {
            NavigationLink(destination: MakeMemojiCardView(isFirst: isFirst)) {
                MakeCardView()
            }
        }
    }
    
    @ViewBuilder
    func MemojiCardHStack() -> some View {
        HStack {
            self.MemojiCard(memojiCardID: viewModel.leftCardID, isFirst: true)
            self.MemojiCard(memojiCardID: viewModel.rightCardID, isFirst: false)
        }
    }
}

// MARK: - PreviewProvider
struct MyMemojiView_Previews: PreviewProvider {
    static var previews: some View {
        MyMemojiView()
    }
}
