//
//  MemojiCardModel.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/04/28.
//

import Foundation

struct MemojiCard: Codable, Hashable {
    var cardID: UUID = UUID()
    var name: String = ""
    var subTitle: String = ""
    var isRight: Bool = false
    var isMyCard: Bool = false
    var imageData: Data = Data()
    var kor: String = ""
    var eng: String = ""
    
    var saveCount: Int = 0
    var token: String
    var description: String = ""
    
    var imageName: String {
        return "\(self.name)___\(self.saveCount)___\(self.token).png"
    }
    
    var airDropURL: String {
        return "MemojiCollector://?cardID=\(cardID.uuidString)"
    }
    
    var urlString: String {
        return "MemojiCollector://?" + ("imageName=\(self.imageName)&kor=\(self.kor)&eng=\(self.eng)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
    }
    
    var urlScheme: URL? {
        return URL(string: self.urlString)
    }
    
}
