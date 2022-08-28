//
//  StorageManager.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/08/13.
//

import Foundation
import FirebaseStorage

enum StorageManager {
    static func getImageData(imageName: String, completeHandler: @escaping (Data) -> ()) {
        let storage = Storage.storage()
        let pathReference = storage.reference(withPath: imageName)
        pathReference.getData(maxSize: 1 * 1024 * 1024) { optionalData, _ in
            if let data = optionalData {
                completeHandler(data)
            }
        }
    }
}
