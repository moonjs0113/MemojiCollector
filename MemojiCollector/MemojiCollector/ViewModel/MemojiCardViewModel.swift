//
//  MemojiCardViewModel.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/08/13.
//

import SwiftUI

class MemojiCardViewModel: ObservableObject {
    
    var memojiCard: MemojiCard = .init(token: "")
    var imageData: Data = Data()
    
    func loadData(cardID: String, completeHandler: @escaping () -> ()) {
        NetworkService.requestCardData(cardID: cardID) { [weak self] result in
            switch result {
            case .success(let cardDTO):
                self?.memojiCard = MemojiCard(name: cardDTO.userName ?? "",
                                              isMyCard: true,
                                              kor: cardDTO.firstString ?? "",
                                              eng: cardDTO.secondString ?? "",
                                              token: "")
                StorageManager.getImageData(imageName: cardDTO.id?.uuidString ?? "") { [weak self] imageData in
                    self?.imageData = imageData
                    completeHandler()
                }
            case .failure(let error):
                debugPrint(error)
                completeHandler()
            }
        }
    }
}
