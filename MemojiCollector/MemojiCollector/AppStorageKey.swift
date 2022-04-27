//
//  AppStorageKey.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/04/27.
//

import Foundation

enum AppStorageKey: String {
    case userName, userSession, firstUser
    case firstCardImage, secondCardImage
    case firstCard, secondCard
    
    var string: String {
        switch self {
        case .userName:
            return "USER_NAME"
        case .userSession:
            return "USER_SESSION"
        case .firstUser:
            return "FIRST_USER"
        case .firstCard:
            return "FIRST_CARD"
        case .secondCard:
            return "SECOND_CARD"
        case .firstCardImage:
            return "FIRST_CARD_Image"
        case .secondCardImage:
            return "SECOND_CARD_Image"
        }
    }
}
