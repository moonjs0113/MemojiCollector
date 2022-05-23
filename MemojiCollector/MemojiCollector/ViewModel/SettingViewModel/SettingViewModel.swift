//
//  SettingViewModel.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/05/23.
//

import SwiftUI

class SettingViewModel: ObservableObject {
    @AppStorage(AppStorageKey.firstUser.string) var firstUser: Bool = true
    @AppStorage(AppStorageKey.password.string) var userPW: String = ""
    @Published var showUnlockView: Bool = false
    @Published var goToPasswordView: Bool = false
}