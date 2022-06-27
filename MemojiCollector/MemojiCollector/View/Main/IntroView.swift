//
//  IntroView.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/06/23.
//

import SwiftUI
import MemojiCollectorStaticLibrary
public typealias LockView = MemojiCollectorStaticLibrary.LockView


struct IntroView: View {
    @AppStorage(AppStorageKey.cardList.string) var cardInfoList: Data = Data()
    
    @State private var showAlert: Bool = false
    @State var isLock: Bool
    @State var receiveMemojiCard: MemojiCard?
    
    var body: some View {
        if self.isLock {
            LockView(isLock: self.$isLock)
                .onOpenURL { URL in
                    self.receiveMemojiCard = self.convertURLtoMemojiCard(url: URL)
                }
        } else {
            MainView()
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
                .onAppear {
                    if self.receiveMemojiCard != nil {
                        self.showAlert = true
                    }
                }
        }
    }
}

struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        IntroView(isLock: false)
    }
}
