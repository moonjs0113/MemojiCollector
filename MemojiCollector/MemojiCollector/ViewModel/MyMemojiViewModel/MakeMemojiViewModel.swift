//
//  MakeMemojiViewModel.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/05/04.
//

import SwiftUI
import FirebaseStorage

class MakeMemojiViewModel: ObservableObject {
    // MARK: - AppStorage
    @AppStorage(AppStorageKey.userName.string) var userName = ""
    @AppStorage(AppStorageKey.saveCount.string) var saveCount: Int = 0
    @AppStorage(AppStorageKey.cardList.string) var cardInfoList: Data = Data()
    @AppStorage(AppStorageKey.token.string) var token: String = ""
    
    // MARK: - Published
    @Published var selectedImage: UIImage = UIImage()
    @Published var selectedMemoji: UIImage = UIImage()
    @Published var isSelecteImage: Bool = false
    @Published var korean: String = "#"
    @Published var english: String = "#"
    
    @Published var isComplete: Bool = false
    
    var isFirst: Bool = false
    
    func createMemojiModel(uploadMethod: String) -> MemojiCard{
        let memojiCard = MemojiCard(name: self.userName,
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
    
    func hangulTextCheck(newValue: String) {
        let pattern = "^[가-힣ㄱ-ㅎㅏ-ㅣ0-9_# ]{2,20}$"
        let regex = try? NSRegularExpression(pattern: pattern)
        if regex?.firstMatch(in: newValue, options: [], range: NSRange(location: 0, length: newValue.count)) == nil {
            if self.korean.count == 0 {
                self.korean = "#"
            } else if self.korean.count > 1 {
                _ = self.korean.removeLast()
            }
        } else {
            if self.korean.last == "#" {
                _ = self.korean.removeLast()
            }
        }
    }
    
    func englishTextCheck(newValue: String){
        let pattern = "^[a-zA-Z0-9_# ]{2,20}$"
        let regex = try? NSRegularExpression(pattern: pattern)
        if regex?.firstMatch(in: newValue, options: [], range: NSRange(location: 0, length: newValue.count)) == nil {
            if self.english.count == 0 {
                self.english = "#"
            } else if self.english.count > 1 {
                _ = self.english.removeLast()
            }
        } else {
            if self.english.last == "#" {
                _ = self.english.removeLast()
            }
        }
    }
    
    func isEmptySomeData() -> Bool{
        print(#function)
        return self.english.count < 2 || self.korean.count < 2 || !self.isSelecteImage
    }
    
    func saveImageToStorage(memojiModel: MemojiCard, progressHandler: @escaping (StorageTaskSnapshot) -> Void) {
        let storage = Storage.storage()
        let storageRef = storage.reference().child(memojiModel.imageName)
        let metaDataDictionary: [String : Any] = [ "contentType" : "image/png" ]
        
        let storageMetadata = StorageMetadata(dictionary: metaDataDictionary)
        let uploadImageData = self.normalizationToData(imageData: memojiModel.imageData)
        let uploadTask = storageRef.putData(uploadImageData, metadata: storageMetadata)
        uploadTask.observe(.progress, handler: progressHandler)
    }
    
    func normalizationToData(imageData: Data) -> Data {
        if let image = UIImage(data: imageData) {
            let maxLength = (image.size.height < image.size.width ? image.size.width : image.size.height)
            let resizingRadio = (maxLength / 1280 > 1 ? maxLength / 1280 : 1)
            let resizedImage = self.resizingImage(image: image,
                                                  targetSize: CGSize(width: image.size.width/resizingRadio,
                                                                     height: image.size.height/resizingRadio)
            )
            var compressionQuality:CGFloat = 1.0
            var data = resizedImage.jpegData(compressionQuality: compressionQuality)!
            var dataSizeMB = Float(data.count / 1024) / Float(1024)
            while dataSizeMB > (500 / 1024) {
                compressionQuality = compressionQuality - 0.005
                data = resizedImage.jpegData(compressionQuality: compressionQuality)!
                dataSizeMB = Float(data.count / 1024) / Float(1024)
            }
            return data
        }
        return Data()
    }
    
    func resizingImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
