//
//  RegisterUserView.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/04/27.
//

import SwiftUI

struct RegisterUserView: View {
    @AppStorage(AppStorageKey.userName.string) private var userName = ""
    @AppStorage(AppStorageKey.userSession.string) private var userSession = "Morning"
    
    @AppStorage(AppStorageKey.firstUser.string) private var firstUser: Bool = true
    
    @Environment(\.dismiss) var dismiss
    
    @State private var showAlert = false
    
    @Binding var isShowMyPage: Bool
    
    var body: some View {
        VStack {
            VStack(spacing:40) {
                Text("기본 정보 등록")

                VStack(spacing: 8) {
                    HStack(spacing: 5) {
                        Text("닉네임    ")
                        TextField("NickName", text: self.$userName)
                    }
                    .padding(.leading, 15)
                    Divider()
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("Session")
                    Picker("",selection: self.$userSession) {
                        ForEach(["Morning", "Afternoon"], id: \.self) { session in
                            Text(session)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Text("*중복 데이터 방지를 위해 닉네임과 세션은 이후 변경할 수 없습니다.\n변경을 위해서는 어플을 재설치 해야하며, 수집한 미모지 카드는 저장되지 않습니다.")
                    .font(.caption)
            }
            .padding(.top, 25)

            Spacer()
            Button {
                if self.userName != "" {
                    self.showAlert.toggle()
                }
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 15, style: .circular)
                        .fill(Color("MainColor"))
                    Text("등록하기")
                        .font(.title)
                        .foregroundColor(.white)
                }
            }
            .frame(height: 60)
            .alert("등록하시겠습니까?", isPresented: self.$showAlert) {
                Button("No", role: .cancel) { }
                Button("Yes", role: .none){
                    self.firstUser = false
                    self.dismiss()
                }
            } message: {
                Text("닉네임: \(self.userName)\n세션: \(self.userSession)")
            }
            .disabled(self.userName == "")
        }
        .padding()
        .onDisappear {
            if self.firstUser == false {
                self.isShowMyPage = true
            }
        }
    }
}

//struct RegisterUserView_Previews: PreviewProvider {
//    static var previews: some View {
//        RegisterUserView()
//    }
//}
