//
//  MemojiCollectorApp.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/04/27.
//

import SwiftUI


@main
struct MemojiCollectorApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @AppStorage(AppStorageKey.cardList.string) var cardInfoList: Data = Data()
    @State private var showAlert: Bool = false
    @State var receiveMemojiCard: MemojiCard?

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { URL in
                    self.receiveMemojiCard = self.convertURLtoMemojiCard(url: URL)
                    self.showAlert = true
                }
                .alert("\(self.receiveMemojiCard?.name ?? "")의 미모지 카드가 왔습니다!", isPresented: self.$showAlert) {
                    Button("받기", role: .none) {
                        if let memoji = self.receiveMemojiCard {
                            self.saveData(receiveMemojiCard: memoji)
                        }
                        self.receiveMemojiCard = nil
                    }
                    Button("😭", role: .cancel) {
                        self.receiveMemojiCard = nil
                    }
                }
        }
    }
}

