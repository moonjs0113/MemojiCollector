//
//  MemojiCardView.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/04/27.
//

import SwiftUI
import Firebase

struct MemojiCardView: View {
    var memojiCard: MemojiCard
    var preImageData: Data = Data()
    @State private var imageData: Data = Data()
    
    
    init(memojiCard: MemojiCard, preImageData: Data = Data()) {
        self.memojiCard = memojiCard
        self.preImageData = preImageData
        print("\(memojiCard.kor) init")
    }
    
    func addImageData(memoji: MemojiCard) {
        let storage = Storage.storage()
        let pathReference = storage.reference(withPath: "\(memoji.imageName)")
        pathReference.getData(maxSize: 1 * 1024 * 1024) { optionalData, _ in
            if let data = optionalData {
                self.imageData = data
                self.updateImageData(memojiCard: memojiCard, imageData: data)
            }
        }
    }
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("\(self.memojiCard.kor)\n\(self.memojiCard.eng) ")
                    .lineLimit(2)
                    .font(.system(.caption, design: .rounded))
                    .minimumScaleFactor(0.01)
                    .multilineTextAlignment(.leading)
                    .frame(alignment: .leading)
                    .foregroundColor(Color("MainColor"))
                    .padding(.horizontal, 10)
                Spacer()
                
                VStack(alignment: .center) {
                    if self.imageData.count == 0  {
                        ProgressView(.init())
                            .progressViewStyle(.circular)
                            .scaledToFit()
                            .frame(minWidth: 50, maxWidth: .infinity, minHeight: 50, maxHeight: .infinity, alignment: .bottom)
                    } else {
                        Image(uiImage: (UIImage(data: imageData) ?? UIImage()))
                            .resizable()
                            .scaledToFit()
                            .frame(minWidth: 50, maxWidth: .infinity, minHeight: 50, maxHeight: .infinity, alignment: .bottom)
                    }
                    
                    Text(self.memojiCard.name)
                        .font(.system(.title, design: .rounded))
                        .fontWeight(.bold)
                        .lineLimit(1)
                        .foregroundColor(Color("MainColor"))
                }
            }
            .padding()
            .padding(.top, 10)
        }
        .frame(minWidth: 10, maxWidth: .infinity, minHeight: 10, maxHeight: .infinity)
        .aspectRatio(11/17, contentMode: .fit)
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(lineWidth: 1)
                .foregroundColor(Color(red: 200/255, green: 200/255, blue: 200/255))
        }
        .onAppear{
            self.imageData = self.preImageData
            if self.imageData.count == 0 {
                self.addImageData(memoji: self.memojiCard)
            }
        }
    }
}

struct MemojiCardView_Previews: PreviewProvider {
    static var previews: some View {
        MemojiCardView(memojiCard: MemojiCard(token: ""))
    }
}
