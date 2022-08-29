//
//  MemojiDetailView.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/04/27.
//

import SwiftUI

struct MemojiDetailView: View {
    @StateObject var viewModel: MemojiDetaillViewModel = MemojiDetaillViewModel()
    @State var memojiCard: MemojiCard
    
    @State private var showAlert = false
    @State private var showSaveImageAlert = false
    @State private var isActivityViewPresented: Bool = false
    @State private var isQRCodeViewPresented: Bool = false
    
    
    @State private var cardRect: CGRect = .zero
    
    @FocusState var isFocus: Bool
    @Environment(\.dismiss) var dismiss
    
    var cardView: some View {
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
                    if memojiCard.imageData.count == 0 {
                        ProgressView(value: 0.0)
                            .progressViewStyle(.circular)
                            .frame(minWidth: 50, maxWidth: .infinity, minHeight: 50, maxHeight: .infinity, alignment: .bottom)
                    } else {
                        Image(uiImage: (UIImage(data: self.memojiCard.imageData) ?? UIImage()))
                            .resizable()
                            .scaledToFit()
                            .frame(minWidth: 50, maxWidth: .infinity, minHeight: 50, maxHeight: .infinity, alignment: .bottom)
                            .cornerRadius(20)
                            .clipped()
                    }
                    Text(self.memojiCard.name)
                        .font(.system(.largeTitle, design: .rounded))
                        .fontWeight(.bold)
                        .lineLimit(1)
                        .foregroundColor(.black)
                        .minimumScaleFactor(0.05)
                    Text(self.memojiCard.subTitle)
                        .font(.system(.body, design: .rounded))
                        .lineLimit(1)
                        .foregroundColor(.gray)
                        .minimumScaleFactor(0.05)
                }
                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom, 30)
            Spacer()
        }
        .aspectRatio(11/17, contentMode: .fit)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .shadow(color: .gray.opacity(0.5), radius: 3, x: 0, y: 2)
        }
        .frame(minWidth: 50, maxWidth: .infinity, minHeight: 50, maxHeight: .infinity)
        .padding()
    }
    
    var body: some View {
        ScrollView {
            VStack {
                cardView
                    .padding(.horizontal,40)
                    .onTapGesture {
                        self.isFocus = false
                    }
                    .layoutPriority(1)
                
                Spacer()
                
                if self.viewModel.isEditing {
                    VStack(alignment: .leading) {
                        VStack(alignment: .leading) {
                            Text("부제(최대20자)")
                                .frame(alignment: .leading)
                        }
                        
                        TextField("최대 20자까지 저장 가능합니다.", text: self.$memojiCard.subTitle)
                            .frame(height: 25)
                            .padding(5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10, style: .circular)
                                    .stroke(lineWidth: 1)
                                    .fill(.gray)
                            )
                            .focused(self.$isFocus)
                        
                        VStack(alignment: .leading) {
                            Text("메모")
                                .frame(alignment: .leading)
                        }
                        .frame(alignment: .leading)
                        .multilineTextAlignment(.leading)
                        TextEditor(text: self.$viewModel.memojiMemo)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10, style: .circular)
                                    .stroke(lineWidth: 1)
                                    .fill(.gray)
                            )
                            .frame(minWidth: 50, maxWidth: .infinity, minHeight: 70, maxHeight: 100)
                            .focused(self.$isFocus)
                    }
                    .padding([.horizontal, .bottom])
                }
            }
            .onAppear{
                StorageManager.getCardImage(imageName: memojiCard.cardID.uuidString) { imageData in
                    self.memojiCard.imageData = imageData
                }
                viewModel.memojiCard = memojiCard
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        self.isFocus = false
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing:
                                    HStack {
                
                if self.memojiCard.isMyCard {
                    Button {
                        self.showAlert.toggle()
                    } label: {
                        Image(systemName: "trash")
                    }
                    Menu {
                        Button {
                            self.isActivityViewPresented.toggle()
                        } label: {
                            HStack {
                                Image(systemName: "airplayaudio")
                                Text("AirDrop으로 공유하기")
                            }
                        }
                        
                        Button {
                            self.isQRCodeViewPresented.toggle()
                        } label: {
                            HStack {
                                Image(systemName: "qrcode")
                                Text("QR Code로 공유하기")
                            }
                        }
                        
                        Button {
                            self.viewModel.convertViewUIImage(cardView: cardView)
                            
                        } label: {
                            Image(systemName: "square.and.arrow.down")
                            Text("이미지로 저장하기")
                        }
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                    
                } else {
                    if self.viewModel.isEditing {
                        Button {
                            self.showAlert.toggle()
                        } label: {
                            Image(systemName: "trash")
                        }
                    }
                    Button {
                        withAnimation {
                            self.memojiCard = self.viewModel.willBeginEditing(newMemojiCard: self.memojiCard)
                        }
                    } label: {
                        Text(self.viewModel.isEditing ? "완료" : "편집")
                    }
                }
            }
            )
            .sheet(isPresented: self.$isActivityViewPresented) {
                MemojiActivityViewController(memojiModel: self.memojiCard)
            }
            .sheet(isPresented: self.$isQRCodeViewPresented) {
                QRCodeView(memojiModel: self.memojiCard)
            }
            .alert("삭제하시겠습니까?", isPresented: self.$showAlert) {
                Button("No", role: .cancel) { }
                Button("Yes", role: .none){
                    viewModel.deleteMemojiCard() { result in
                        switch result {
                        case .success(_):
                            break
                        case .failure(let error):
                            debugPrint(error)
                        }
                        DispatchQueue.main.async {
                            self.dismiss()
                        }
                    }
                }
            } message: {
                Text("삭제 후엔 되돌릴 수 없습니다.")
            }
            .alert("저장완료", isPresented: self.$showSaveImageAlert) {
                
            } message: {
                Text("미모지 카드가 저장되었습니다.")
            }
        }
        
    }
}

struct MemojiDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MemojiDetailView(memojiCard: MemojiCard(token: ""))
    }
}
