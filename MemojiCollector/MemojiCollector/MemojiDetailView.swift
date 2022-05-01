//
//  MemojiDetailView.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/04/27.
//

import SwiftUI

struct MemojiDetailView: View {
    var memojiCard: MemojiCard
    @AppStorage(AppStorageKey.cardList.string) private var cardInfoList: Data = Data()
    
    @State private var showAlert = false
    @State private var isActivityViewPresented: Bool = false
    
    @Environment(\.dismiss) var dismiss
    
    func deleteMemojiCard() {
        var memojiList: [MemojiCard] = JsonManager.shared.jsonDecoder(decodingData: self.cardInfoList)
        memojiList.removeAll{
            $0.isFirst == self.memojiCard.isFirst && $0.token == self.memojiCard.token
        }
        self.cardInfoList = JsonManager.shared.jsonEncoder(ecodingData: memojiList)
        if self.memojiCard.isMyCard {
            self.removeImageToStorage(memojiModel: self.memojiCard)
        }
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
                        .foregroundColor(Color("MainColor"))
                        .padding(.top, 35)
                        .padding(.horizontal, 30)
                    
                    VStack {
                        Image(uiImage: (UIImage(data: self.memojiCard.imageData) ?? UIImage()))
                            .resizable()
                            .scaledToFit()
                            .frame(minWidth: 50, maxWidth: .infinity, minHeight: 50, maxHeight: .infinity, alignment: .bottom)
                            .cornerRadius(20)
                            .clipped()
                        Text(self.memojiCard.name)
                            .font(.system(.largeTitle, design: .rounded))
                            .fontWeight(.bold)
                            .lineLimit(1)
                            .foregroundColor(Color("MainColor"))
                    }
                    Spacer()
                }
                .padding()
                .padding(.bottom, 30)
            }
            .frame(minWidth: 50, maxWidth: .infinity, minHeight: 50, maxHeight: .infinity)
            .aspectRatio(11/17, contentMode: .fit)
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(lineWidth: 2)
                    .foregroundColor(Color(red: 200/255, green: 200/255, blue: 200/255))
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
                self.deleteMemojiCard()
                self.dismiss()
            }
        } message: {
            Text("삭제 후엔 되돌릴 수 없습니다.")
        }
    }
}

//struct MemojiDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        MemojiDetailView(memojiCard: MemojiCard())
//    }
//}
