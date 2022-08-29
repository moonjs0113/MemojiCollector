//
//  StorageManager.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/08/13.
//

import Foundation
import FirebaseStorage

enum StorageManager {
    static func getCardImage(imageName: String, completeHandler: @escaping (Data) -> ()) {
        let storage = Storage.storage()
        let pathReference = storage.reference(withPath: imageName)
        pathReference.getData(maxSize: 1 * 1024 * 1024) { optionalData, _ in
            if let data = optionalData {
                completeHandler(data)
            }
        }
    }
    
    static func uploadCardImage(imageData: Data, cardID: UUID, progressHandler: @escaping (StorageTaskSnapshot) -> Void) {
        let storage = Storage.storage()
        let storageRef = storage.reference().child(cardID.uuidString)
        let metaDataDictionary: [String : Any] = [ "contentType" : "image/png" ]
        
        let storageMetadata = StorageMetadata(dictionary: metaDataDictionary)
        let uploadTask = storageRef.putData(imageData, metadata: storageMetadata)
        uploadTask.observe(.success, handler: progressHandler)
    }
    
    static func removeCardImage(cardID: String) {
        let storage = Storage.storage()
        let storageRef = storage.reference().child(cardID)
        storageRef.delete()
    }
}
