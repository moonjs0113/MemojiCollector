//
//  SettingView.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/05/11.
//

import SwiftUI

struct SettingView: View {
    @StateObject private var viewModel: SettingViewModel = SettingViewModel()

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
                    .sheet(isPresented: self.$viewModel.showUnlockView) { LockView(isLock: self.$viewModel.goToPasswordView, sha256: self.viewModel.userPW) }
                }
                if !self.viewModel.firstUser {
                    NavigationLink("닉네임 변경", destination: ChangeNameView())
                }
            }
            Section {
                NavigationLink("앱 초기화", destination: ResetView())
            }
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
