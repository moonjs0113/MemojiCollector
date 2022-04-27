//
//  EnumValue.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/04/27.
//

import Foundation

enum AppStorageKey: String {
    case userName, userSession, firstUser
    
    var string: String {
        switch self {
        case .userName:
            return "USER_NAME"
        case .userSession:
            return "USER_SESSION"
        case .firstUser:
            return "FIRST_USER"
        }
    }
}
