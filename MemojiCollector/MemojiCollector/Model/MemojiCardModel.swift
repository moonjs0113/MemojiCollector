//
//  MemojiCardModel.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/04/28.
//

import Foundation

struct MemojiCard: Codable, Hashable {
    var name: String = ""
    var session: String = ""
    var isFirst: Bool = true
    var isMyCard: Bool = false
    var imageData: Data = Data()
    var kor: String = ""
    var eng: String = ""
    
    var token: String
    
    var imageName: String {
        return "\(self.name)___\(self.isFirst ? 0 : 1)___\(self.token).png"
    }
    
    var urlString: String {
        return "MemojiCollector://?imageName=\(self.imageName)&kor=\(self.kor)&eng=\(self.eng)&session=\(self.session)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
    
    var urlScheme: URL? {
        return URL(string: self.urlString)
    }
}
