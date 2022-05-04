//
//  MemojiDetailView.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/04/27.
//

import SwiftUI

struct MemojiDetailView: View {
    @StateObject var viewModel: MemojiDetaillViewModel = MemojiDetaillViewModel()
    var memojiCard: MemojiCard
    
    @State private var showAlert = false
    @State private var isActivityViewPresented: Bool = false
    
    @Environment(\.dismiss) var dismiss
    
    init(memojiCard: MemojiCard) {
        self.memojiCard = memojiCard
        self.viewModel.memojiCard = memojiCard
    }
    
    var body: some View {
        VStack {
            VStack{
                VStack(alignment: .leading) {
                    Text("\(self.memojiCard.kor)\n\(self.memojiCard.eng)")
                        .lineLimit(2)
                        .font(.system(.title, design: .rounded))
                        .minimumScaleFactor(0.01)
                        .multilineTextAlignment(.leading)
                        .frame(alignment: .leading)
                        .foregroundColor(.black)
                        .padding(.top, 35)
                        .padding(.horizontal, 30)
                    
                    VStack {
                        Image(uiImage: (UIImage(data: self.memojiCard.imageData) ?? UIImage()))
                            .resizable()
                            .scaledToFit()
                            .frame(minWidth: 50, maxWidth: .infinity, minHeight: 50, maxHeight: .infinity, alignment: .bottom)
                            .cornerRadius(20)
                            .clipped()
                            .onAppear()
                        Text(self.memojiCard.name)
                            .font(.system(.largeTitle, design: .rounded))
                            .fontWeight(.bold)
                            .lineLimit(1)
                            .foregroundColor(.black)
                    }
                    Spacer()
                }
                .padding()
                .padding(.bottom, 30)
            }
            .frame(minWidth: 50, maxWidth: .infinity, minHeight: 50, maxHeight: .infinity)
            .aspectRatio(11/17, contentMode: .fit)
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white)
                    .shadow(color: .gray.opacity(0.5), radius: 3, x: 0, y: 2)
            }
            .padding(50)
        }
        .navigationBarItems(trailing:
                                HStack {
            Button {
                self.showAlert.toggle()
            } label: {
                Image(systemName: "trash")
            }
            if self.memojiCard.isMyCard {
                Button {
                    self.isActivityViewPresented.toggle()
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
                            
        )
        .sheet(isPresented: self.$isActivityViewPresented) {
            MemojiActivityViewController(memojiModel: self.memojiCard)
        }
        .alert("삭제하시겠습니까?", isPresented: self.$showAlert) {
            Button("No", role: .cancel) { }
            Button("Yes", role: .none){
                self.viewModel.deleteMemojiCard() {
                    self.dismiss()
                }
            }
        } message: {
            Text("삭제 후엔 되돌릴 수 없습니다.")
        }
    }
}

struct MemojiDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MemojiDetailView(memojiCard: MemojiCard(token: ""))
    }
}
