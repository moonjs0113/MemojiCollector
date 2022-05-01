//
//  MemojiCollectorApp.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/04/27.
//

import SwiftUI
import Firebase

@main
struct MemojiCollectorApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @AppStorage(AppStorageKey.cardList.string) var cardInfoList: Data = Data()
    @AppStorage(AppStorageKey.token.string) var fcmToken: String = ""
    
    @State private var showAlert: Bool = false
    @State private var receiveMemojiCard: MemojiCard?

    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light)
                .onOpenURL { URL in
                    self.receiveMemojiCard = self.convertURLtoMemojiCard(url: URL)
                    self.showAlert = true
                }
                .onAppear {
                    print("ContentView On Appear FCM Token")
                    print(self.fcmToken)
                }
                .alert("\(self.receiveMemojiCard?.name ?? "")의 미모지 카드가 왔습니다!", isPresented: self.$showAlert) {
                    Button("받기", role: .none) {
                        if let memoji = self.receiveMemojiCard {
                            self.saveData(memojiCard: memoji)
//                            self.addImageData(memoji: memoji)
                        }
                        self.receiveMemojiCard = nil
                    }
                    Button("😭", role: .cancel) {
                        self.receiveMemojiCard = nil
                    }
                }
//        message:  {
//                    Text("")
//                }
        }
    }
}

