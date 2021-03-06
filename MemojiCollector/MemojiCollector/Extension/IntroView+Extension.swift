//
//  IntroView+Extension.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/05/01.
//

import Foundation
import Firebase
import SwiftUI

extension IntroView {
    func convertURLtoMemojiCard(url: URL) -> MemojiCard? {
        let urlString = url.absoluteString
        let components = URLComponents(string: urlString)
        var memojiCard = MemojiCard(token: "")
        print(urlString)
        if let queryItems = components?.queryItems {
            for item in queryItems {
                if let kor = item.value, item.name == "kor" {
                    memojiCard.kor = kor
                } else if let eng = item.value, item.name == "eng" {
                    memojiCard.eng = eng
                } else if let imageName = item.value, item.name == "imageName" {
                    if let fileName = imageName.components(separatedBy: ".").first {
                        for (index, string) in fileName.components(separatedBy: "___").enumerated() {
                            if index == 0 {
                                memojiCard.name = string
                            } else if index == 1 {
                                memojiCard.saveCount = Int(string) ?? 0
                            } else if index == 2 {
                                memojiCard.token = string
                            }
                        }
                    }
                } else if let timeStamp = item.value, item.name == "timeStamp" {
                    print(timeStamp.components(separatedBy: " "))
                    let timeStampArray = timeStamp.components(separatedBy: " ")
                    if let date = "\(timeStampArray[0]) \(timeStampArray[1])".convertToDate() {
                        print(Date.now)
                        print(date.addingTimeInterval(60))
                        if Date.now > date.addingTimeInterval(60) {
                            print("못받아!")
                        }
                    }

                }
            }
            return memojiCard
        } else { return nil }
    }
    
    func saveData(receiveMemojiCard: MemojiCard) {
        var memojiList = JsonManager.shared.jsonDecoder(decodingData: self.cardInfoList)
        let memojiCard = receiveMemojiCard
        if memojiList.filter({ $0.urlString == memojiCard.urlString }).isEmpty {
            memojiList.append(memojiCard)
        }
        self.cardInfoList = JsonManager.shared.jsonEncoder(ecodingData: memojiList)
    }
    
}
