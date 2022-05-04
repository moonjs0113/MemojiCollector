//
//  MemojiDetaillViewModel.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/05/04.
//

import SwiftUI
import FirebaseStorage

class MemojiDetaillViewModel: ObservableObject {
    @AppStorage(AppStorageKey.cardList.string) private var cardInfoList: Data = Data()
    
    var memojiCard: MemojiCard = MemojiCard(token: "")
    
    func deleteMemojiCard( completeHandler: @escaping () -> ()) {
        var memojiList: [MemojiCard] = JsonManager.shared.jsonDecoder(decodingData: self.cardInfoList)
        memojiList.removeAll{
            $0.urlString == self.memojiCard.urlString
        }
        self.cardInfoList = JsonManager.shared.jsonEncoder(ecodingData: memojiList)
        
        if self.memojiCard.isMyCard {
            self.removeImageToStorage(memojiModel: self.memojiCard)
        }
        
        completeHandler()
    }
    
    func removeImageToStorage(memojiModel: MemojiCard) {
        let storage = Storage.storage()
        let storageRef = storage.reference().child(memojiModel.imageName)
        storageRef.delete()
    }
}
