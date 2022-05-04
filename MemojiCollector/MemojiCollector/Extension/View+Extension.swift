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
    func removeImageToStorage(memojiModel: MemojiCard) {
        let storage = Storage.storage()
        let storageRef = storage.reference().child(memojiModel.imageName)
        storageRef.delete()
    }
    
    
}
