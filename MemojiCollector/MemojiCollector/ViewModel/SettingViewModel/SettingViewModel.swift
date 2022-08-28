//
//  SettingViewModel.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/05/23.
//

import SwiftUI
import FirebaseStorage

class SettingViewModel: ObservableObject {
    @AppStorage(AppStorageKey.password.string) var userPW: String = ""
    @Published var showUnlockView: Bool = false
    @Published var showResetConfirmationDialog: Bool = false
    @Published var goToPasswordView: Bool = false
    
//    func removeMyMemojiCard() {
//        @AppStorage(AppStorageKey.cardList.string) var cardInfoList: Data = Data()
//        @AppStorage(AppStorageKey.userName.string) var userName = ""
//
//        let _ = JsonManagerClass.shared.jsonDecoder(decodingData: cardInfoList).filter {
//            if $0.isMyCard {
//                self.removeImageToStorage(memojiModel: $0)
//            }
//            return !$0.isMyCard
//        }
//        cardInfoList = Data()
//        userName = ""
//        userPW = ""
//        isUserNameRegister = true
//    }
    
    func initMemojiCollecter() {
        UserDefaultManager.userID = nil
        UserDefaultManager.userName = nil
        if let rightCardID = UserDefaultManager.rightCardID {
            removeImageFromStorage(imageName: rightCardID)
            UserDefaultManager.rightCardID = nil
        }
        if let leftCardID = UserDefaultManager.leftCardID {
            removeImageFromStorage(imageName: leftCardID)
            UserDefaultManager.leftCardID = nil
        }
    }
    
    func removeImageFromStorage(imageName: String) {
        let storage = Storage.storage()
        let storageRef = storage.reference().child(imageName)
        storageRef.delete()
    }
}
