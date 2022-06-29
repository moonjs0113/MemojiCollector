//
//  ChangeNameView.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/05/11.
//

import SwiftUI
import FirebaseStorage

struct ChangeNameView: View {
    @AppStorage(AppStorageKey.userName.string) private var userName = ""
    @State private var newUserName = ""
    @State private var showAlert = false
    @Environment(\.dismiss) var dismiss
    
    func removeMyMemojiCard() {
        @AppStorage(AppStorageKey.cardList.string) var cardInfoList: Data = Data()
        let memojiCardList = JsonManager.shared.jsonDecoder(decodingData: cardInfoList).filter {
            if $0.isMyCard {
                self.removeImageToStorage(memojiModel: $0)
                return false
            } else {
                return true
            }
        }
        cardInfoList = JsonManager.shared.jsonEncoder(ecodingData: memojiCardList)
    }
    
    func removeImageToStorage(memojiModel: MemojiCard) {
        let storage = Storage.storage()
        let storageRef = storage.reference().child(memojiModel.imageName)
        storageRef.delete()
    }
    
    var body: some View {
        VStack(spacing: 10) {
            VStack(spacing: 8) {
                HStack(spacing: 5) {
                    Text("새 닉네임    ")
                    TextField("NickName(최대 10자)", text: self.$newUserName)
                        .onChange(of: self.newUserName) { _ in
                            self.newUserName = self.newUserName.replacingOccurrences(of: " ", with: "")
                        }
                        .keyboardType(.webSearch)
                }
                .padding(.leading, 15)
                Divider()
            }
            .padding(.top, 25)
            
            Text("\(Image(systemName: "exclamationmark.circle")) 닉네임 변경 시, 나의 미모지 카드와 공유한 미모지 카드 모두 삭제됩니다.")
                .font(.caption)
                .foregroundColor(.red)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            Button {
                self.showAlert.toggle()
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 5, style: .circular)
                        .fill(.tint)
                    Text("변경하기")
                        .font(.body)
                        .foregroundColor(.white)
                }
            }
            .disabled(self.newUserName == "" || self.newUserName.count >= 10 || self.newUserName == self.userName)
            .frame(height: 60)
            .alert("변경하시겠습니까? 나의 미모지 카드가 모두 삭제됩니다!", isPresented: self.$showAlert) {
                Button("No", role: .cancel) {
                    self.dismiss()
                }
                Button("Yes", role: .none){
                    self.removeMyMemojiCard()
                    self.userName = self.newUserName
                    self.dismiss()
                }
            }
            .disabled(self.newUserName == "")
        }
        .padding()
        .navigationTitle("닉네임 변경")
    }
}

struct ChangeNameView_Previews: PreviewProvider {
    static var previews: some View {
        ChangeNameView()
    }
}
