//
//  Group.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/05/16.
//

import Foundation

struct Group: Codable, Hashable {
    var name: String = ""
    var memojiCardList: [MemojiCard] = []
}
