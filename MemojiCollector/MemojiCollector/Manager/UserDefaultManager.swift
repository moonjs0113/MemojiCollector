//
//  UserDefaultManager.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/08/29.
//

import Foundation

struct UserDefaultManager {
//    static let shr: UserDefaultManager = UserDefaultManager()
    
    static var userID: String? {
        get {
            guard let userID = UserDefaults.standard.string(forKey: "USER_ID") else {
                return nil
            }
            return userID
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: "USER_ID")
        }
    }
    
    static var userName: String? {
        get {
            guard let userName = UserDefaults.standard.string(forKey: "USER_NAME") else {
                return nil
            }
            return userName
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: "USER_NAME")
        }
    }
    
    static var leftCardID: String? {
        get {
            guard let cardID = UserDefaults.standard.string(forKey: "LEFT_CARD_ID") else {
                return nil
            }
            return cardID
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: "LEFT_CARD_ID")
        }
    }
    
    static var rightCardID: String? {
        get {
            guard let cardID = UserDefaults.standard.string(forKey: "RIGHT_CARD_ID") else {
                return nil
            }
            return cardID
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: "RIGHT_CARD_ID")
        }
    }
    

    
    
    
}
