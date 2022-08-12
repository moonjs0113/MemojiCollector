//
//  RequestDTO.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/08/12.
//

import Foundation

struct RequestDTO: Encodable {
    var userID: UUID?
    var cardID: UUID?
    var userName: String?
    var firstString: String?
    var secondString: String?
    var sharedCardIDs: [String]?
    var isRight: Bool?
}
