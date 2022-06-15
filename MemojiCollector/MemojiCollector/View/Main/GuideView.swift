//
//  GuideView.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/06/15.
//

import SwiftUI

struct GuideView: View {
    var body: some View {
        TabView {
            ForEach(1..<6, id: \.self) { index in
                VStack {
                    Text("GuideImage입니다.")
                    Image("GuideImage_\(index)")
                        .resizable()
                        .scaledToFit()
                        .aspectRatio(contentMode: .fit)
                }
                .padding()
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
    }
}



struct GuideView_Previews: PreviewProvider {
    static var previews: some View {
        GuideView()
    }
}
