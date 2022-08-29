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

    static var isFirstUser: Bool {
        get {
            guard let isFirstUser = UserDefaults.standard.value(forKey: "IS_FIRST_USER") as? Bool else {
                UserDefaults.standard.set(true, forKey: "IS_FIRST_USER")
                return true
            }
            return isFirstUser
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: "IS_FIRST_USER")
        }
    }
    
    static var sharedCardIDList: [String] {
        get {
            guard let sharedCardIDList = UserDefaults.standard.value(forKey: "SHARED_CARD_ID_LIST") as? [String] else {
                return []
            }
            return sharedCardIDList
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: "SHARED_CARD_ID_LIST")
        }
    }
    
}
