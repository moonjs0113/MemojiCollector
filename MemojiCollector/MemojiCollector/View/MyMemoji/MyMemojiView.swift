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
                self.viewModel.setMyMemojiCard()
                .padding(.horizontal, 20)
                Spacer()
            }
            .onAppear {
                self.viewModel.findMemojiCard()
            }
        }
    }
}

struct MyMemojiView_Previews: PreviewProvider {
    static var previews: some View {
        MyMemojiView()
    }
}
