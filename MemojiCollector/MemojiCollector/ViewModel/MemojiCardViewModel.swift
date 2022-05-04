//
//  MemojiCardViewModel.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/05/04.
//

import SwiftUI
import FirebaseStorage

class MemojiCardViewModel: ObservableObject {
    @Published var imageData: Data = Data()
    @Published var isEmptyImage: Bool = false
    var preImageData: Data = Data()
    var memojiCard: MemojiCard?// = MemojiCard(token: "")
    
//        init(memojiCard: MemojiCard) {
//            self.memojiCard = memojiCard
//        }
    
    func addImageData() {
        let storage = Storage.storage()
        if let memojiCard = self.memojiCard {
            let pathReference = storage.reference(withPath: "\(memojiCard.imageName)")
            pathReference.getData(maxSize: 1 * 1024 * 1024) { optionalData, _ in
                if let data = optionalData {
                    self.imageData = data
                    self.updateImageData(imageData: data)
                }
            }
        }
    }
    
    func updateImageData(imageData: Data) {
        @AppStorage(AppStorageKey.cardList.string) var cardListData: Data = Data()
        var cardList = JsonManager.shared.jsonDecoder(decodingData: cardListData)
        if let memojiCard = self.memojiCard {
            cardList.indices.filter{
                cardList[$0].urlString == memojiCard.urlString
            }.forEach { changeIndex in
                cardList[changeIndex].imageData = imageData
                cardListData = JsonManager.shared.jsonEncoder(ecodingData: cardList)
            }
        }
    }
    
    func checkImageExist() {
        let storage = Storage.storage()
        if let memojiCard = self.memojiCard {
            let pathReference = storage.reference(withPath: "\(memojiCard.imageName)")
            pathReference.getMetadata { _, error in
                if let error = error as? NSError {
                    if let errorCode = error.userInfo["ResponseErrorCode"] as? Int, errorCode == 404 {
                        self.isEmptyImage = true
                    }
                }
            }
        }
    }
    
    func syncImageData() {
        if self.imageData.count == 0 {
            self.addImageData()
        } else {
            if !(self.memojiCard?.isMyCard ?? false) {
                self.checkImageExist()
            }
        }
    }
}
