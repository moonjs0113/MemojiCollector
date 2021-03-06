//
//  RegisterUserView.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/04/27.
//

import SwiftUI

struct RegisterUserView: View {
    @AppStorage(AppStorageKey.userName.string) private var userName = ""
    @AppStorage(AppStorageKey.isUserNameRegister.string) private var isUserNameRegister: Bool = true
    @State private var newUserName = ""
    
    @Environment(\.dismiss) var dismiss
    
    @State private var showAlert = false
    
    @Binding var isShowMyPage: Bool
    
    var body: some View {
        VStack {
            VStack(spacing:40) {
                Text("기본 정보 등록")
                VStack(spacing: 20) {
                    VStack(spacing: 8) {
                        HStack(spacing: 5) {
                            Text("닉네임    ")
                            TextField("NickName(최대 10자)", text: self.$newUserName)
                                .onChange(of: self.newUserName) { _ in
                                    self.newUserName = self.newUserName.replacingOccurrences(of: " ", with: "")
                                }
                                .keyboardType(.webSearch)
                        }
                        .padding(.leading, 15)
                        Divider()
                    }
                    
                    Text("\(Image(systemName: "exclamationmark.circle")) 닉네임은 이후 변경이 가능하지만, 변경 시 공유한 미모지 카드를 포함하여 나의 미모지 카드가 모두 삭제됩니다.")
                        .font(.caption)
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(.horizontal, 5)
            .padding(.top, 25)


            Spacer()
            Button {
                self.showAlert.toggle()
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 5, style: .circular)
                        .fill(.tint)
                    Text("등록하기")
                        .font(.body)
                        .foregroundColor(.white)
                }
            }
            .disabled(self.newUserName == "" || self.newUserName.count >= 10)
            .frame(height: 60)
            .alert("저장하시겠습니까?", isPresented: self.$showAlert) {
                Button("No", role: .cancel) { }
                Button("Yes", role: .none){
                    self.userName = self.newUserName
                    self.isUserNameRegister = false
                    self.dismiss()
                }
            } message: {
                Text("닉네임: \(self.newUserName)")
            }
        }
        .padding()
        .onDisappear {
            if self.isUserNameRegister == false {
                self.isShowMyPage = true
            }
        }
    }
}

struct RegisterUserViewPreviewsContainer: View {
    @State var isShowMyPage: Bool = false
    var body: some View {
        RegisterUserView(isShowMyPage: self.$isShowMyPage)
    }
}


struct RegisterUserView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterUserViewPreviewsContainer()
    }
}
