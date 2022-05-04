//
//  EmptyCardView.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/05/03.
//

import SwiftUI

struct EmptyCardView: View {
    var memojiCard: MemojiCard
    
    var body: some View {
        Text("\(self.memojiCard.name)에게\n나머지 카드를 요청해보세요!")
            .foregroundColor(.black)
            .frame(minWidth: 10, maxWidth: .infinity, minHeight: 10, maxHeight: .infinity)
            .aspectRatio(11/17, contentMode: .fit)
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white)
                    .shadow(color: .gray.opacity(0.5), radius: 3, x: 0, y: 1)
            }
    }
}

struct EmptyCardView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyCardView(memojiCard: MemojiCard(token: ""))
    }
}
