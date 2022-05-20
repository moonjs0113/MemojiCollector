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
        VStack(spacing: 40) {
            Text("닉네임 변경 시, 나의 미모지 카드와 공유한 미모지 카드 모두 삭제됩니다.")
                .padding(.top, 25)
            
            Text("변경할 닉네임")
            VStack(spacing: 8) {
                HStack(spacing: 5) {
                    Text("닉네임    ")
                    TextField("NickName", text: self.$newUserName)
                }
                .padding(.leading, 15)
                Divider()
            }
            Spacer()
            
            Button {
                if self.newUserName != "" {
                    self.showAlert.toggle()
                }
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 5, style: .circular)
                        .fill(.tint)
                    Text("변경하기")
                        .font(.body)
                        .foregroundColor(.white)
                }
            }
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
        
    }
}

struct ChangeNameView_Previews: PreviewProvider {
    static var previews: some View {
        ChangeNameView()
    }
}
