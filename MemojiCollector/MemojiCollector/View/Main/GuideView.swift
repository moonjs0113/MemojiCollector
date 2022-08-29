//
//  GuideView.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/06/15.
//

import SwiftUI

struct GuideView: View {
    let guideTitle = [
        "나의 미모지 카드 만들기",
        "미모티콘 스티커와 문구 작성",
        "미모지 카드 공유하기",
    ]
    let guideContent = [
        "비어있는 카드를 선택하여\n나의 미모지 카드를 만들어보세요!",
        "나만의 미모티콘 스티커와 문구로\n미모지 카드를 자유롭게 꾸며보세요!",
        "완성된 카드를 선택하여 확인하고,\n에어드랍과 QR코드를 통해 친구들과 공유해보세요!",
    ]
    
    init() {
        UIPageControl.appearance().currentPageIndicatorTintColor = .systemBlue
        UIPageControl.appearance().pageIndicatorTintColor = .systemBlue.withAlphaComponent(0.2)
    }
    
    var body: some View {
        TabView {
            ForEach(0..<3, id: \.self) { index in
                VStack(spacing: 30) {
                    VStack(alignment: .center, spacing: 50) {
                        Image("Onboarding\(index)")
                            .resizable()
                            .scaledToFit()
                            .aspectRatio(contentMode: .fit)
                            .padding(.top, 30)
                        
                        VStack(spacing: 12) {
                            Text(guideTitle[index])
                                .font(.title)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                            
                            Text(guideContent[index])
                                .font(.callout)
                                .multilineTextAlignment(.center)
                        }
                    }
                    Rectangle()
                        .fill(.clear)
                        .frame(height: 30)
                }
                .padding(.horizontal)
            }
        }
        .onDisappear {
            UserDefaultManager.isFirstUser = false
        }
        .tabViewStyle(PageTabViewStyle())
    }
}



struct GuideView_Previews: PreviewProvider {
    static var previews: some View {
        GuideView()
    }
}
