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
    @State private var readNotice = false
    @Environment(\.dismiss) var dismiss
    
    func removeMyMemojiCard() {
        @AppStorage(AppStorageKey.cardList.string) var cardInfoList: Data = Data()
        @AppStorage(AppStorageKey.userName.string) var userName = ""
        @AppStorage(AppStorageKey.isUserNameRegister.string) var isUserNameRegister: Bool = true
        
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
        isUserNameRegister = true
    }
    
    func removeImageToStorage(memojiModel: MemojiCard) {
        let storage = Storage.storage()
        let storageRef = storage.reference().child(memojiModel.imageName)
        storageRef.delete()
    }
    
    var body: some View {
        VStack(spacing: 40) {
            VStack(spacing: 10){
                Text("===== 주의 사항 =====")
                .frame(alignment: .center)
                .minimumScaleFactor(0.5)
                Text("나의 정보와 미모지 카드, 내가 받은 미모지 카드가 모두 삭제되며 삭제 후 복구가 불가능 합니다.")
                    .padding(.top, 25)
                
                HStack {
                    Button {
                        self.readNotice.toggle()
                    } label: {
                        if self.readNotice {
                            Image(systemName: "checkmark.square.fill")
                                .foregroundColor(.blue)
                        } else {
                            Image(systemName: "square")
                        }
                    }
                    Text("위 주의사항을 확인했습니다.")
                    Spacer()
                    
                }
                .padding(.top, 25)
                .padding(.horizontal, 5)
            }

            Spacer()
            
            Button {
                self.showAlert.toggle()
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 5, style: .circular)
                        .fill(.tint)
                    Text("초기화 하기")
                        .font(.body)
                        .foregroundColor(.white)
                }
            }
            .disabled(!self.readNotice)
            .frame(height: 60)
            .alert("정말 초기화 하시겠습니까?", isPresented: self.$showAlert) {
                Button("No", role: .cancel) {
                    self.dismiss()
                }
                Button("Yes", role: .destructive){
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
