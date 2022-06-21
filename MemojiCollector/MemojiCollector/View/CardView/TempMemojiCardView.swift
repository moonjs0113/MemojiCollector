//
//  TempMemojiCardView.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/06/15.
//

import SwiftUI

struct TempMemojiCardView: View {
    let textColor = Color.black
    
    var body: some View {
        VStack{
            VStack(alignment: .leading) {
                Text("#나만의_미모지_카드를_만드세요\n#Share_Your_Card_Using_AirDrop")
                    .lineLimit(2)
                    .font(.system(.caption, design: .rounded))
                    .minimumScaleFactor(0.01)
                    .multilineTextAlignment(.leading)
                    .frame(alignment: .leading)
                    .foregroundColor(self.textColor)
                    .padding(.horizontal, 10)
                Spacer()
                
                VStack(alignment: .center) {
                    Image("TempImage")
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(10)
                        .clipped()
                        .frame(minWidth: 50, maxWidth: .infinity, minHeight: 50, maxHeight: .infinity, alignment: .bottom)
                    
                    Text("Memoji")
                        .font(.system(.title, design: .rounded))
                        .fontWeight(.bold)
                        .lineLimit(1)
                        .foregroundColor(self.textColor)
                    VStack(alignment: .center) {
                        Text("친구의 카드에 메모를 남기세요!")
                            .frame(alignment: .center)
                            .font(.system(.caption2, design: .rounded))
                            .lineLimit(1)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding()
            .padding(.top, 10)
        }
        .frame(minWidth: 10, maxWidth: .infinity, minHeight: 10, maxHeight: .infinity)
        .aspectRatio(11/17, contentMode: .fit)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .shadow(color: .gray.opacity(0.5), radius: 3, x: 0, y: 1)
        }        
    }
}

struct TempMemojiCardView_Previews: PreviewProvider {
    static var previews: some View {
        TempMemojiCardView()
    }
}
