//
//  CardDTO.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/08/12.
//

import Foundation

struct CardDTO: Codable {
    var id: UUID?
    var userName: String?
    var firstString: String?
    var secondString: String?
}