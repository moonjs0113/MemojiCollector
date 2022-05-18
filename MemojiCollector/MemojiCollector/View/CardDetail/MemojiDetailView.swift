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
    @State private var isActivityViewPresented: Bool = false
    @State private var isEditing: Bool = false
    @State private var memojiMemo: String = ""
    
    @FocusState var isFocus: Bool
    @Environment(\.dismiss) var dismiss
    
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
            .frame(minWidth: 50, maxWidth: .infinity, minHeight: 50, maxHeight: .infinity)
            .aspectRatio(11/17, contentMode: .fit)
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white)
                    .shadow(color: .gray.opacity(0.5), radius: 3, x: 0, y: 2)
            }
            .padding(.top, 10)
            .padding(.horizontal,50)
            .onTapGesture {
                self.isFocus = false
            }
            
            Spacer()
            
            if self.isEditing {
                VStack {
                    VStack(alignment: .leading) {
                        Text("부제")
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
                        
                    VStack(alignment: .leading) {
                        Text("메모")
                            .frame(alignment: .leading)
                    }
                    .frame(alignment: .leading)
                    .multilineTextAlignment(.leading)
                    TextEditor(text: self.$memojiMemo)
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
            self.memojiMemo = self.memojiCard.description
            self.viewModel.loadMemojiCard(memojiCard: self.memojiCard)
            self.memojiCard = self.viewModel.memojiCard
            //            print(self.memojiCard.group)
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
                Button {
                    self.isActivityViewPresented.toggle()
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
            } else {
                if self.isEditing {
                    Button {
                        self.showAlert.toggle()
                    } label: {
                        Image(systemName: "trash")
                    }
                }
                Button {
                    withAnimation {
                        if self.isEditing {
                            var subTitle = ""
                            if self.memojiCard.subTitle.count > 20 {
                                subTitle = String(self.memojiCard.subTitle[..<self.memojiCard.subTitle.endIndex])
                            } else {
                                subTitle = self.memojiCard.subTitle
                            }
                            self.viewModel.memojiCard.description = self.memojiMemo
                            self.viewModel.memojiCard.subTitle = subTitle
                                
                            self.viewModel.editMemojiDescription()
                        }
                        self.isEditing.toggle()
                    }
                } label: {
                    Text(self.isEditing ? "완료" : "편집")
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
