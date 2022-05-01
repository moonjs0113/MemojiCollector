//
//  App+Extension.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/05/01.
//

import Foundation
import Firebase

extension  MemojiCollectorApp {
    func convertURLtoMemojiCard(url: URL) -> MemojiCard? {
        let urlString = url.absoluteString
        let components = URLComponents(string: urlString)
        var memojiCard = MemojiCard(token: "")
        
        if let queryItems = components?.queryItems {
            for item in queryItems {
                if let kor = item.value, item.name == "kor" {
                    memojiCard.kor = kor
                } else if let eng = item.value, item.name == "eng" {
                    memojiCard.eng = eng
                } else if let session = item.value, item.name == "session" {
                    memojiCard.session = session
                } else if let imageName = item.value, item.name == "imageName" {
                    if let fileName = imageName.components(separatedBy: ".").first {
                        for (index, string) in fileName.components(separatedBy: "___").enumerated() {
                            if index == 0 {
                                memojiCard.name = string
                            } else if index == 1 {
                                memojiCard.isFirst = (string == "0")
                            } else if index == 2 {
                                memojiCard.token = string
                            }
                        }
                    }
                }
            }
            return memojiCard
        } else { return nil }
    }
    
    func saveData(memojiCard: MemojiCard) {
        var memojiList = JsonManager.shared.jsonDecoder(decodingData: self.cardInfoList)
        memojiList.append(memojiCard)
        self.cardInfoList = JsonManager.shared.jsonEncoder(ecodingData: memojiList)
    }
}