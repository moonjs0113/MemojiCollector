//
//  GuideView.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/06/15.
//

import SwiftUI

struct GuideView: View {
    @AppStorage(AppStorageKey.firstGuide.string) private var firstGuide: Bool = true
    
    let guideText = [
        "닉네임을 설정하고, 나의 미모지를 확인하세요!",
        "비어있는 카드를 선택하여 나의 미모지를 만들어보세요!",
        "미모지 스티커는 설정에서 활성화된 상태로\n미모지 키보드의 가장 왼쪽에서 확인할 수 있습니다.",
        "나만의 문구를 한글과 영어로 작성하세요!",
        "완성된 카드를 선택하여 확인하고, 에어드랍을 통해 친구들과 공유해보세요!",
    ]
    
    func gokKeyboardSetting() {
        if let url = URL(string: "App-prefs:General&path=Keyboard") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    init() {
        UIPageControl.appearance().currentPageIndicatorTintColor = .systemBlue
        UIPageControl.appearance().pageIndicatorTintColor = .black.withAlphaComponent(0.2)
    }
    
    var body: some View {
        TabView {
            ForEach(1..<6, id: \.self) { index in
                VStack {
                    Text(guideText[index-1])
                        .padding(.top, 20)
                    
                    if index == 3 {
                        Button {
                            self.gokKeyboardSetting()
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 5, style: .circular)
                                    .fill(.tint)
                                Text("미모지 스티커 활성화 하러가기")
                                    .font(.body)
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(height: 64)
                    }
                    
                    Spacer()
                    
                    Image("GuideImage_\(index)")
                        .resizable()
                        .scaledToFit()
                        .aspectRatio(contentMode: .fit)
                    
                    Rectangle()
                        .fill(.clear)
                        .frame(height: 30)
                }
                .padding(.horizontal)
            }
        }
        .onDisappear {
            firstGuide = false
        }
        .tabViewStyle(PageTabViewStyle())
    }
}



struct GuideView_Previews: PreviewProvider {
    static var previews: some View {
        GuideView()
    }
}
