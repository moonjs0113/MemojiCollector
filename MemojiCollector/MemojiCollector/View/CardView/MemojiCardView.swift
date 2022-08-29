//
//  MemojiCardView.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/08/13.
//

import SwiftUI

struct MemojiCardView: View {
    
    let cardID: String
    let isRight: Bool
    @State private var isCompleteLoad: Bool = false
    @StateObject var viewModel: MemojiCardViewModel = MemojiCardViewModel()
    
    init(cardID: String, isRight: Bool) {
        self.cardID = cardID
        self.isRight = isRight
    }
    
    var body: some View {
        VStack {
            if isCompleteLoad {
                NavigationLink(destination: MemojiDetailView(memojiCard: viewModel.memojiCard)) {
                    VStack(alignment: .leading) {
                        Text("\(viewModel.memojiCard.kor)\n\(viewModel.memojiCard.eng)")
                            .lineLimit(2)
                            .font(.system(.caption, design: .rounded))
                            .minimumScaleFactor(0.01)
                            .multilineTextAlignment(.leading)
                            .frame(alignment: .leading)
                            .foregroundColor(.black)
                            .padding(.horizontal, 10)
                        Spacer()

                        VStack(alignment: .center) {
                            if self.viewModel.imageData.count == 0  {
                                ProgressView(.init())
                                    .progressViewStyle(.circular)
                                    .scaledToFit()
                                    .frame(minWidth: 50, maxWidth: .infinity, minHeight: 50, maxHeight: .infinity, alignment: .bottom)
                            } else {
                                Image(uiImage: (UIImage(data: self.viewModel.imageData) ?? UIImage()))
                                    .resizable()
                                    .scaledToFit()
                                    .cornerRadius(10)
                                    .clipped()
                                    .frame(minWidth: 50, maxWidth: .infinity, minHeight: 50, maxHeight: .infinity, alignment: .bottom)
                            }

                            Text(viewModel.memojiCard.name)
                                .font(.system(.title, design: .rounded))
                                .fontWeight(.bold)
                                .lineLimit(1)
                                .foregroundColor(.black)
                            if !(viewModel.memojiCard.isMyCard) {
                                VStack(alignment: .center) {
                                    Text(viewModel.memojiCard.subTitle)
                                        .frame(alignment: .center)
                                        .font(.system(.caption2, design: .rounded))
                                        .lineLimit(1)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                    .padding()
                    .padding(.top, 10)
                }
                .disabled(viewModel.imageData.count == 0)

            } else {
                ProgressView()
                    .progressViewStyle(.circular)
            }
        }
        .frame(minWidth: 10, maxWidth: .infinity, minHeight: 10, maxHeight: .infinity)
        .aspectRatio(11/17, contentMode: .fit)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .shadow(color: .gray.opacity(0.5), radius: 3, x: 0, y: 1)
        }
        .onAppear{
            viewModel.loadData(cardID: cardID, isRight: isRight) {
                isCompleteLoad = true
            }
        }
    }
}

struct MemojiCardView_Previews: PreviewProvider {
    static var previews: some View {
        MemojiCardView(cardID: "", isRight: true)
    }
}
