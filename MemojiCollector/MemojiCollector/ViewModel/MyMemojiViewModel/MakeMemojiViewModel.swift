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
    @AppStorage("LEFT_CARD_ID") var leftCardID = ""
    @AppStorage("RIGHT_CARD_ID") var rightCardID = ""
    @AppStorage("USER_ID") private var userID: String = ""
    
    // MARK: - Published
    @Published var selectedMemoji: UIImage = UIImage()
    @Published var isSelecteImage: Bool = false
    @Published var firstString: String = "#"
    @Published var secondString: String = "#"
    
    @Published var isComplete: Bool = false
    
    /// true: 왼쪽, right: 오른쪽
    var isRight: Bool = false
    
    func createMemojiModel() -> MemojiCard{
        let memojiCard = MemojiCard(name: self.userName,
                                    isRight: self.isRight,
                                    isMyCard: true,
                                    imageData: self.selectedMemoji.pngData() ?? Data(),
                                    kor: self.firstString.replacingOccurrences(of: " ", with: "_"),
                                    eng: self.secondString.replacingOccurrences(of: " ", with: "_"),
                                    saveCount: self.saveCount,
                                    token: self.token)
        return memojiCard
    }
    
    func registerCardID(completeHandler: @escaping (NetworkError?) -> ()) {
        let requestDTO = RequestDTO(userID: UUID(uuidString: userID),
                                    userName: userName,
                                    firstString: firstString,
                                    secondString: secondString,
                                    isRight: isRight)
        
        NetworkService.requestCreateCard(requestDTO: requestDTO) { [weak self] result in
            switch result {
            case .success(let cardDTO):
                guard let cardID = cardDTO.id else {
                    completeHandler(.nilResponse)
                    return
                }
                let imageData = self?.selectedMemoji.pngData() ?? Data()
                StorageManager.uploadCardImage(imageData: imageData, cardID: cardID) { snapshot in
                    let percentComplete = Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
                    if percentComplete == 1.0 {
                        self?.fetchCardID(cardID: cardID)
                        completeHandler(nil)
                    }
                }
                return
            case .failure(let error):
                debugPrint(error)
            }
            completeHandler(.nilResponse)
        }
    }
    
    func fetchCardID(cardID: UUID) {
        if isRight {
            rightCardID = cardID.uuidString
        } else {
            leftCardID = cardID.uuidString
        }
    }
    
    func isEnableRegister() -> Bool {
        return (self.firstString.count > 1 && self.secondString.count > 1 && self.isSelecteImage)
    }
    
    func firstTextCheck(newValue: String) {
        if newValue.count == 0 {
            self.firstString = "#"
        } else if newValue.count > 21 {
            self.firstString = String(Array(newValue)[0..<21])
        }
    }
    
    func secondTextCheck(newValue: String) {
        if newValue.count == 0 {
            self.secondString = "#"
        } else if newValue.count > 21 {
            self.secondString = String(Array(newValue)[0..<21])
        }
    }
    
    func isEmptySomeData() -> Bool{
        return self.secondString.count < 2 || self.firstString.count < 2 || !self.isSelecteImage
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
