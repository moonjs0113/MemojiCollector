//
//  AppDelegate.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/04/30.
//

import Foundation
import Firebase
import FirebaseMessaging
import SwiftUI
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    @AppStorage(AppStorageKey.token.string) private var fcmToken: String = ""
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                self.fcmToken = token
            }
        }
        return true
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let fcmToken = fcmToken {
            self.fcmToken = fcmToken
        }
    }
}





