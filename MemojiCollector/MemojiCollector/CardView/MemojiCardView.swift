//
//  MemojiCardView.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/04/27.
//

import SwiftUI
import Firebase

struct MemojiCardView: View {
    let textColor = Color.black // Color("MainColor")
    
    var memojiCard: MemojiCard
    var preImageData: Data = Data()
    @State private var imageData: Data = Data()
    @State private var isEmptyImage: Bool = false
    
    init(memojiCard: MemojiCard, preImageData: Data = Data()) {
        self.memojiCard = memojiCard
        self.preImageData = preImageData
        print(self)
        self.addImageData(memoji: self.memojiCard)
    }
    
    func addImageData(memoji: MemojiCard) {
        let storage = Storage.storage()
        let pathReference = storage.reference(withPath: "\(memoji.imageName)")
        pathReference.getData(maxSize: 1 * 1024 * 1024) { optionalData, _ in
            if let data = optionalData {
                self.imageData = data
                self.updateImageData(memojiCard: self.memojiCard, imageData: data)
            }
        }
    }
    
    func checkImageExist() {
        let storage = Storage.storage()
        let pathReference = storage.reference(withPath: "\(self.memojiCard.imageName)")
        pathReference.getMetadata { _, error in
            if let error = error as? NSError {
                if let errorCode = error.userInfo["ResponseErrorCode"] as? Int, errorCode == 404 {
                    self.isEmptyImage = true
                }
            }
        }
    }
    
    var body: some View {
        VStack {
            if self.isEmptyImage {
                DeletedCardView(memojiCard: self.memojiCard)
            } else {
                NavigationLink(destination: MemojiDetailView(memojiCard: self.memojiCard)) {
                    VStack(alignment: .leading) {
                        Text("\(self.memojiCard.kor)\n\(self.memojiCard.eng) ")
                            .lineLimit(2)
                            .font(.system(.caption, design: .rounded))
                            .minimumScaleFactor(0.01)
                            .multilineTextAlignment(.leading)
                            .frame(alignment: .leading)
                            .foregroundColor(self.textColor)
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
                                    .onAppear {
                                        print("Card Image")
                                        print("Image Data Size: \(self.imageData)")
                                    }
                            }
                            
                            Text(self.memojiCard.name)
                                .font(.system(.title, design: .rounded))
                                .fontWeight(.bold)
                                .lineLimit(1)
                                .foregroundColor(self.textColor)
                            if !self.memojiCard.isMyCard {
                                VStack(alignment: .leading) {
                                    Text(self.memojiCard.session)
                                        .frame(alignment: .leading)
                                        .font(.system(.caption2, design: .rounded))
                                        .lineLimit(1)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                    .padding()
                    .padding(.top, 10)
                }
                .disabled(self.imageData.count == 0)
            }
        }
        .frame(minWidth: 10, maxWidth: .infinity, minHeight: 10, maxHeight: .infinity)
        .aspectRatio(11/17, contentMode: .fit)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .shadow(color: .gray.opacity(0.5), radius: 3, x: 0, y: 1)
        }
        .onAppear{
            self.imageData = self.preImageData
            if self.imageData.count == 0 {
                print("self.imageData.count is 0")
                print("I am \(self.memojiCard.kor)")
                self.addImageData(memoji: self.memojiCard)
            } else {
                if !self.memojiCard.isMyCard {
                    self.checkImageExist()
                }
            }
        }
    }
}

struct MemojiCardView_Previews: PreviewProvider {
    static var previews: some View {
        MemojiCardView(memojiCard: MemojiCard(token: ""))
    }
}
