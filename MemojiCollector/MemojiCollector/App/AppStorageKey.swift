//
//  AppStorageKey.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/04/27.
//

import Foundation

enum AppStorageKey: String {
    case token, firstUser, saveCount
    case userName, userSession
    case cardList, groupList
    
    var string: String {
        switch self {
        case .token:
            return "FCM_TOKEN"
        case .userName:
            return "USER_NAME"
        case .userSession:
            return "USER_SESSION"
        case .firstUser:
            return "FIRST_USER"
        case .saveCount:
            return "SAVE_COUNT"
        case .cardList:
            return "CARD_LIST"
        case .groupList:
            return "GROUP_LIST"
        }
    }
}
