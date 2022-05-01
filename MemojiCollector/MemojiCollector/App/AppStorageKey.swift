//
//  AppStorageKey.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/04/27.
//

import Foundation

enum AppStorageKey: String {
    case token, firstUser
    case userName, userSession
    case cardList
//    case myCardInfo, otherCardInfo
    
    
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
        case .cardList:
            return "CARD_LIST"
//        case .myCardInfo:
//            return "MY_CARD_INFO"
//        case .otherCardInfo:
//            return "OTHER_CARD_INFO"
        }
    }
}