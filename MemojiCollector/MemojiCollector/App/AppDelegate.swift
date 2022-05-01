//
//  AppDelegate.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/04/30.
//

import Foundation
import FirebaseMessaging
import SwiftUI
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    @AppStorage(AppStorageKey.token.string) private var fcmToken: String = ""
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        Messaging.messaging().delegate = self
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                print("FCM registration token: \(token)")
                self.fcmToken = token
            }
        }
//        print("fcmToken: \(Messaging.messaging().fcmToken)")
        
        return true
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print(#function)
        if let fcmToken = fcmToken {
            print(self.fcmToken)
            self.fcmToken = fcmToken
        }
    }
}





