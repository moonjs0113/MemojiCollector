//
//  MakeMemojiViewModel.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/05/04.
//

import SwiftUI
import FirebaseStorage

class MakeMemojiViewModel: ObservableObject {
    @AppStorage(AppStorageKey.userName.string) var userName = ""
    @AppStorage(AppStorageKey.userSession.string) var userSession = "Morning"
    @AppStorage(AppStorageKey.saveCount.string) var saveCount: Int = 0
    @AppStorage(AppStorageKey.cardList.string) var cardInfoList: Data = Data()
    @AppStorage(AppStorageKey.token.string) var token: String = ""
    
    @Published var selectedImage: UIImage = UIImage()
    @Published var selectedMemoji: UIImage = UIImage()
    @Published var isSelecteImage: Bool = false
    @Published var korean: String = "#"
    @Published var english: String = "#"
    
    var isFirst: Bool = false
    
    func createMemojiModel(uploadMethod: String) -> MemojiCard{
        let memojiCard = MemojiCard(name: self.userName,
                                    session: self.userSession,
                                    isFirst: self.isFirst,
                                    isMyCard: true,
                                    imageData: (uploadMethod == "사진" ? self.selectedImage : self.selectedMemoji).pngData() ?? Data(),
                                    kor: self.korean.replacingOccurrences(of: " ", with: "_"),
                                    eng: self.english.replacingOccurrences(of: " ", with: "_"),
                                    saveCount: self.saveCount,
                                    token: self.token)
        return memojiCard
    }
    
    func saveData(memojiCard: MemojiCard, completeHandler: @escaping () -> ()) {
        var memojiList = JsonManager.shared.jsonDecoder(decodingData: self.cardInfoList)
        memojiList.append(memojiCard)
        self.cardInfoList = JsonManager.shared.jsonEncoder(ecodingData: memojiList)
        self.saveImageToStorage(memojiModel: memojiCard) { snapshot in
            let percentComplete = Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
            if percentComplete == 1.0 {
                self.saveCount += 1
                completeHandler()
            }
        }
    }
    
    func isEnableRegister() -> Bool {
        return (self.korean.count > 1 && self.english.count > 1 && self.isSelecteImage)
    }
    
    func initMemojiImage(uploadMethod: String) {
        if uploadMethod == "사진" {
            self.selectedMemoji = UIImage()
        } else {
            self.isSelecteImage = false
            self.selectedImage = UIImage()
        }
    }
    
    func saveImageToStorage(memojiModel: MemojiCard, progressHandler: @escaping (StorageTaskSnapshot) -> Void) {
        let storage = Storage.storage()
        let storageRef = storage.reference().child(memojiModel.imageName)
        let metaDataDictionary: [String : Any] = [ "contentType" : "image/png" ]
        
        let storageMetadata = StorageMetadata(dictionary: metaDataDictionary)
        let uploadTask = storageRef.putData(memojiModel.imageData, metadata: storageMetadata)
        
        uploadTask.observe(.progress, handler: progressHandler)
    }
    
    func hangulTextCheck(newValue: String) {
        let pattern = "^[가-힣ㄱ-ㅎㅏ-ㅣ0-9_#]{2,20}$"
        let regex = try? NSRegularExpression(pattern: pattern)
        if regex?.firstMatch(in: newValue, options: [], range: NSRange(location: 0, length: newValue.count)) == nil {
            if self.korean.count == 0 {
                self.korean = "#"
            } else if self.korean.count > 1 {
                _ = self.korean.removeLast()
            }
        }
    }
    
    func englishTextCheck(newValue: String){
        let pattern = "^[a-zA-Z0-9_#]{2,20}$"
        let regex = try? NSRegularExpression(pattern: pattern)
        if regex?.firstMatch(in: newValue, options: [], range: NSRange(location: 0, length: newValue.count)) == nil {
            if self.english.count == 0 {
                self.english = "#"
            } else if self.english.count > 1 {
                _ = self.english.removeLast()
            }
        }
    }
    
}
