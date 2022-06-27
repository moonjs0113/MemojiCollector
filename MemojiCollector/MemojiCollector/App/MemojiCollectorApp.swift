//
//  MemojiCollectorApp.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/04/27.
//

import SwiftUI
import MemojiCollectorStaticLibrary

public typealias AppStorageKey = MemojiCollectorStaticLibrary.AppStorageKey

//public typealias AppStorageKey = MemojiCollectorStaticLibrary.AppStorageKey
//public typealias LockView = MemojiCollectorStaticLibrary.LockView
//public typealias PasswordView = MemojiCollectorStaticLibrary.PasswordView

@main
struct MemojiCollectorApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @AppStorage(AppStorageKey.password.string) var userPW: String = ""
    
    var body: some Scene {
        WindowGroup {
            IntroView(isLock: (self.userPW != ""))
        }
    }
}

