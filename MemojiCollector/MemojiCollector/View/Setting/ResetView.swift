//
//  ResetView.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/05/11.
//

import SwiftUI
import FirebaseStorage

struct ResetView: View {
    @State private var showAlert = false
    @Environment(\.dismiss) var dismiss
    
    func removeMyMemojiCard() {
        @AppStorage(AppStorageKey.cardList.string) var cardInfoList: Data = Data()
        @AppStorage(AppStorageKey.userName.string) var userName = ""
        @AppStorage(AppStorageKey.firstUser.string) var firstUser: Bool = true
        
        let _ = JsonManager.shared.jsonDecoder(decodingData: cardInfoList).filter {
            if $0.isMyCard {
                self.removeImageToStorage(memojiModel: $0)
                return false
            } else {
                return true
            }
        }
        cardInfoList = Data()
        userName = ""
        firstUser = true
    }
    
    func removeImageToStorage(memojiModel: MemojiCard) {
        let storage = Storage.storage()
        let storageRef = storage.reference().child(memojiModel.imageName)
        storageRef.delete()
    }
    
    var body: some View {
        VStack(spacing: 40) {
            Text("""
나의 정보와 미모지 카드, 내가 받은 미모지 카드가 모두 삭제되며
삭제 후 복구가 불가능 합니다.
""")
                .padding(.top, 25)
            Spacer()
            
            Button {
                self.showAlert.toggle()
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 15, style: .circular)
                        .fill(Color("MainColor"))
                    Text("초기화 하기")
                        .font(.title)
                        .foregroundColor(.white)
                }
            }
            .frame(height: 60)
            .alert("정말 초기화 하시겠습니까?", isPresented: self.$showAlert) {
                Button("No", role: .cancel) {
                    self.dismiss()
                }
                Button("Yes", role: .none){
                    self.removeMyMemojiCard()
                    
                    self.dismiss()
                }
            }
        }
        .padding()
    }
}

struct ResetView_Previews: PreviewProvider {
    static var previews: some View {
        ResetView()
    }
}
