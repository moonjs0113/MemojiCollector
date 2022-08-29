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
    @AppStorage("LEFT_CARD_ID") var leftCardID = ""
    @AppStorage("RIGHT_CARD_ID") var rightCardID = ""
    @Published var isEditing: Bool = false
    @Published var memojiMemo: String = ""
    
    var memojiCard: MemojiCard = MemojiCard(token: "")

    func deleteMemojiCard( completeHandler: @escaping NetworkClosure) {
        if memojiCard.isMyCard {
            if memojiCard.isRight {
                rightCardID = ""
            } else {
                leftCardID = ""
            }
            
            let requestDTO = RequestDTO(userID: UUID(uuidString: UserDefaultManager.userID ?? ""), cardID: memojiCard.cardID, isRight: memojiCard.isRight)
            NetworkService.requestDeleteCard(requestDTO: requestDTO) { result in
                StorageManager.removeCardImage(cardID: self.memojiCard.cardID.uuidString)
                completeHandler(result)
            }
        }
    }
    
    func editMemojiDescription() {
        var memojiList: [MemojiCard] = JsonManagerClass.shared.jsonDecoder(decodingData: self.cardInfoList)
        if let index = memojiList.map({ $0.urlString }).firstIndex(of: self.memojiCard.urlString) {
            memojiList[index] = self.memojiCard
        }
        self.cardInfoList = JsonManagerClass.shared.jsonEncoder(ecodingData: memojiList)
    }
    
    func convertViewUIImage<V: View>(cardView: V) {
        let controller = UIHostingController(rootView: cardView
            .edgesIgnoringSafeArea(.all))
        guard let view = controller.view else {
            return
        }
        let contentSize = view.intrinsicContentSize
        view.bounds = CGRect(origin: .zero, size: contentSize)
        view.backgroundColor = .clear
        
        let renderer = UIGraphicsImageRenderer(size: contentSize)
        let uiImage = renderer.image { _ in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
        UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil)
    }
    
    func willBeginEditing(newMemojiCard: MemojiCard) -> MemojiCard {
        self.memojiCard = newMemojiCard
        if self.isEditing {
            var subTitle = ""
            if self.memojiCard.subTitle.count > 20 {
                subTitle = String(self.memojiCard.subTitle[..<self.memojiCard.subTitle.index(self.memojiCard.subTitle.startIndex, offsetBy: 20)])
            } else {
                subTitle = self.memojiCard.subTitle
            }
            self.memojiCard.subTitle = subTitle
            self.memojiCard.description = self.memojiMemo
            self.editMemojiDescription()
        }
        self.isEditing.toggle()
        
        return self.memojiCard
    }
}
