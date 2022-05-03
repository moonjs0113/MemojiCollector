//
//  MakeCardView.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/05/03.
//

import SwiftUI

struct MakeCardView: View {
    let buttonSize: CGFloat = 60
    
    var body: some View {
        ZStack {
//            Color("MainColor").opacity(0.1)
//                .cornerRadius(20)
            Circle()
                .fill(.tint)
                .frame(width: self.buttonSize, height: self.buttonSize)
            Image(systemName: "plus")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .tint(.white)
                .frame(width: self.buttonSize - 15, height: self.buttonSize - 15)
        }
        .frame(minWidth: 50, maxWidth: .infinity, minHeight: 50, maxHeight: .infinity)
        .aspectRatio(11/17, contentMode: .fit)
//        .overlay(
//            RoundedRectangle(cornerRadius: 20)
//                .stroke(lineWidth: 1)
//                .foregroundColor(Color(red: 200/255, green: 200/255, blue: 200/255))
//        )
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .shadow(color: .gray.opacity(0.5), radius: 3, x: 0, y: 1)
        }
        
    }
}

struct MakeCardView_Previews: PreviewProvider {
    static var previews: some View {
        MakeCardView()
    }
}
