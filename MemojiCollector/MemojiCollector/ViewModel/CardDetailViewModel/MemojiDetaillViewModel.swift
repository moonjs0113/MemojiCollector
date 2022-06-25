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
    @Published var isEditing: Bool = false
    @Published var memojiMemo: String = ""
    
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
    
    func editMemojiDescription() {
        var memojiList: [MemojiCard] = JsonManager.shared.jsonDecoder(decodingData: self.cardInfoList)
        if let index = memojiList.map({ $0.urlString }).firstIndex(of: self.memojiCard.urlString) {
            print("Change Memoji Card")
            memojiList[index] = self.memojiCard
        }
        self.cardInfoList = JsonManager.shared.jsonEncoder(ecodingData: memojiList)
    }
    
    func loadMemojiCard(memojiCard: MemojiCard) {
        let memojiList: [MemojiCard] = JsonManager.shared.jsonDecoder(decodingData: self.cardInfoList)
        memojiList.forEach {
            if $0.urlString == memojiCard.urlString {
                self.memojiCard = $0
            }
        }
        self.memojiMemo = self.memojiCard.description
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
