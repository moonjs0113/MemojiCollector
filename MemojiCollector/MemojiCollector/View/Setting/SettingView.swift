//
//  SettingView.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/05/11.
//

import SwiftUI

struct SettingView: View {
    @StateObject private var viewModel: SettingViewModel = SettingViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        List {
            Section {
                HStack { 
                    Button {
                        if self.viewModel.userPW == "" {
                            self.viewModel.goToPasswordView.toggle()
                        } else {
                            self.viewModel.showUnlockView.toggle()
                        }
                    } label: {
                        NavigationLink("비밀번호 설정", isActive: self.$viewModel.goToPasswordView) { PasswordView() }
                            .foregroundColor(.black)
                    }
                    .sheet(isPresented: self.$viewModel.showUnlockView) { LockView(isLock: self.$viewModel.goToPasswordView) }
                }
                if !self.viewModel.isUserNameRegister {
                    NavigationLink("닉네임 변경", destination: ChangeNameView())
                }
            }
            Section {
                Button("앱 초기화") {
                    self.viewModel.showResetConfirmationDialog.toggle()
                }
                .foregroundColor(.black)
            }
        }
        .confirmationDialog(Text("앱 초기화"),
                            isPresented: self.$viewModel.showResetConfirmationDialog,
                            titleVisibility: .visible) {
            Button("초기화", role: .destructive) {
                self.viewModel.removeMyMemojiCard()
                self.dismiss()
            }
            Button("취소", role: .cancel) {
                
            }
        } message: {
            Text("나의 정보와 미모지 카드, 내가 받은 미모지 카드가 모두 삭제되며 삭제 후 복구가 불가능 합니다.")
        }
        .navigationTitle("설정")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
