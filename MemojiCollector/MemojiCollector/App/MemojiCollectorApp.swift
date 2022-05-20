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
//                .onAppear {
//                    let memojiCardList: [MemojiCard] = [
//                        MemojiCard(name: "Ghost", isFirst: true, isMyCard: false, imageData: UIImage(named: "Ghost0")!.pngData() ?? Data(), kor: "#엘렐레", eng: "#LOL", saveCount: 0, token: "fGogpyr3yE3dl56K9u4opC:APA91bGZmh0hTADm5jdnrbppaVTVcD0RC3haMlEGt3zPVKFoRVTGFfvVvhP954ikcnwWSnn0smVwk9hfUAHsGsmwJQ4lddu-ig3qrpRFXdEnO4RpY-XNPA4kK8WfVGlcrlnMWG-Ph3Id"),
//                        MemojiCard(name: "Ghost", isFirst: false, isMyCard: false, imageData: UIImage(named: "Ghost1")?.pngData() ?? Data(), kor: "#코코넨네", eng: "#Zzzz", saveCount: 2, token: "fGogpyr3yE3dl56K9u4opC:APA91bGZmh0hTADm5jdnrbppaVTVcD0RC3haMlEGt3zPVKFoRVTGFfvVvhP954ikcnwWSnn0smVwk9hfUAHsGsmwJQ4lddu-ig3qrpRFXdEnO4RpY-XNPA4kK8WfVGlcrlnMWG-Ph3Id"),
//                        MemojiCard(name: "Rey", isFirst: true, isMyCard: false, kor: "#흠", eng: "#hmmmmm", saveCount: 0, token: "f64bw9JVxEdlg8Bc_9FMGY:APA91bEHA6Nl1yOdkwqI8gjsRzHR5ff7XsvvVWw9ku_Cep-QGpihb7guT5I_yDGoMbU9O64X4tlqe-bPx4ba3q2LYu3Ht8pUzfPnxo16rM4UiFfC9C13ctfCkSqKRG2TLoatV0Xzdm_H"),
//                        MemojiCard(name: "Rey", isFirst: false, isMyCard: false, kor: "#밤_하늘의_퍼얼", eng: "#Counting_Stars", saveCount: 2, token: "f64bw9JVxEdlg8Bc_9FMGY:APA91bEHA6Nl1yOdkwqI8gjsRzHR5ff7XsvvVWw9ku_Cep-QGpihb7guT5I_yDGoMbU9O64X4tlqe-bPx4ba3q2LYu3Ht8pUzfPnxo16rM4UiFfC9C13ctfCkSqKRG2TLoatV0Xzdm_H")
//                    ]
//                    self.cardInfoList = JsonManager.shared.jsonEncoder(ecodingData: memojiCardList)
//
//                }
        }
    }
}

