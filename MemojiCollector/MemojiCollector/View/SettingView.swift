//
//  SettingView.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/05/11.
//

import SwiftUI

struct SettingView: View {
    @AppStorage(AppStorageKey.firstUser.string) private var firstUser: Bool = true
    
    var body: some View {
        List {
            Section {
                NavigationLink("비밀번호 설정", destination: Text("비밀번호 설정"))
                NavigationLink("그룹 설정", destination: Text("그룹 설정"))
                if !firstUser {
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
