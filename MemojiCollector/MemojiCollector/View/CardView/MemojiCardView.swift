//
//  MemojiCardView.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/04/27.
//

import SwiftUI
import Firebase

struct MemojiCardView: View {
    @StateObject var viewModel: MemojiCardViewModel = MemojiCardViewModel()
    
    let textColor = Color.black
    
    var memojiCard: MemojiCard
    var preImageData: Data = Data()
    
    init(memojiCard: MemojiCard, preImageData: Data = Data()) {
        self.memojiCard = memojiCard
        self.preImageData = preImageData
    }
    
    var body: some View {
        VStack {
            if self.viewModel.isEmptyImage {
                DeletedCardView(memojiCard: self.viewModel.memojiCard)
            } else {
                NavigationLink(destination: MemojiDetailView(memojiCard: self.viewModel.memojiCard ?? MemojiCard(token: ""))) {
                    VStack(alignment: .leading) {
                        Text("\(self.viewModel.memojiCard?.kor ?? "")\n\(self.viewModel.memojiCard?.eng ?? "")")
                            .lineLimit(2)
                            .font(.system(.caption, design: .rounded))
                            .minimumScaleFactor(0.01)
                            .multilineTextAlignment(.leading)
                            .frame(alignment: .leading)
                            .foregroundColor(self.textColor)
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
                            
                            Text(self.viewModel.memojiCard?.name ?? "")
                                .font(.system(.title, design: .rounded))
                                .fontWeight(.bold)
                                .lineLimit(1)
                                .foregroundColor(self.textColor)
                            if !(self.viewModel.memojiCard?.isMyCard ?? false) {
                                VStack(alignment: .center) {
                                    Text(self.viewModel.memojiCard?.subTitle ?? "")
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
                .disabled(self.viewModel.imageData.count == 0)
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
            self.viewModel.memojiCard = self.memojiCard
            self.viewModel.imageData = self.preImageData
            self.viewModel.syncImageData()
        }
    }
}

struct MemojiCardView_Previews: PreviewProvider {
    static var previews: some View {
        MemojiCardView(memojiCard: MemojiCard(token: ""))
    }
}
