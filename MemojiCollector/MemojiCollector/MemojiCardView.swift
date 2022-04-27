//
//  MemojiCardView.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/04/27.
//

import SwiftUI

struct MemojiCardView: View {
    var isFirst: Bool
    
    @AppStorage(AppStorageKey.userName.string) private var userName = ""
    
    @AppStorage(AppStorageKey.firstCard.string) private var firstCardInfo = ""
    @AppStorage(AppStorageKey.secondCard.string) private var secondCardInfo = ""
    
    @AppStorage(AppStorageKey.firstCardImage.string) private var firstCardImage = Data()
    @AppStorage(AppStorageKey.secondCardImage.string) private var secondCardImage = Data()
    
    @State private var dataString = ""
    @State private var kor = ""
    @State private var eng = ""
    
    
    var body: some View {
        VStack{
            Text(self.kor)
            Text(self.eng)
            Image(uiImage: UIImage(data: self.isFirst ? self.firstCardImage : self.secondCardImage) ?? UIImage())
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
            Text(self.userName)
        }
        .padding()
        .onAppear {
            self.dataString = self.isFirst ? self.firstCardInfo : self.secondCardInfo
            if let url = URL(string: self.dataString) {
                let urlStr = url.absoluteString // [스키마 주소값 가지고 온다]
                let components = URLComponents(string: urlStr) // 전체 주소
                if let queryItems = components?.queryItems {
                    for item in queryItems {
                        if let kor = item.value, item.name == "kor" {
                            self.kor = kor
                        } else if let eng = item.value, item.name == "eng" {
                            self.eng = eng
                        }
                        
                    }
                }
            }
        }
    }
}

struct MemojiCardView_Previews: PreviewProvider {
    static var previews: some View {
        MemojiCardView(isFirst: true)
    }
}
