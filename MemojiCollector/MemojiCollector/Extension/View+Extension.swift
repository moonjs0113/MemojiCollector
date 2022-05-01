//
//  View+Extension.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/04/28.
//

import Foundation
import SwiftUI
import Firebase

extension View {
    func saveImageToStorage(memojiModel: MemojiCard, progressHandler: @escaping (StorageTaskSnapshot) -> Void) {
        let storage = Storage.storage()
        let storageRef = storage.reference().child(memojiModel.imageName)
        let metaDataDictionary: [String : Any] = [ "contentType" : "image/png" ]
        
        let storageMetadata = StorageMetadata(dictionary: metaDataDictionary)
        let uploadTask = storageRef.putData(memojiModel.imageData, metadata: storageMetadata)
        
        uploadTask.observe(.progress, handler: progressHandler)
    }
    
    func removeImageToStorage(memojiModel: MemojiCard) {
        let storage = Storage.storage()
        let storageRef = storage.reference().child(memojiModel.imageName)
        storageRef.delete()
    }
    
    func updateImageData(memojiCard: MemojiCard, imageData: Data) {
        @AppStorage(AppStorageKey.cardList.string) var cardListData: Data = Data()
        var cardList = JsonManager.shared.jsonDecoder(decodingData: cardListData)
        cardList.indices.filter{
            (cardList[$0].token == memojiCard.token) && (cardList[$0].isFirst == memojiCard.isFirst)
        }.forEach { changeIndex in
            print("save \(cardList[changeIndex].kor) image")
            cardList[changeIndex].imageData = imageData
            cardListData = JsonManager.shared.jsonEncoder(ecodingData: cardList)
        }
    }
}
