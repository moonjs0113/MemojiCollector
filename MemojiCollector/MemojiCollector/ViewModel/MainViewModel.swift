//
//  MainViewModel.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/06/25.
//

import SwiftUI

class MainViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var isShowMyPage = false
    @Published var isShowGuideView = false
    @Published var isShowUpdateAlert = false
    
    var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyyMMdd"
        return dateFormatter
    }
    
    func setCancelUpdateDate() {
        guard let nextDateInt = Int(self.dateFormatter.string(from: Date.now)) else {
            return
        }
        
        UserDefaults.standard.set(nextDateInt, forKey: AppStorageKey.updateAlert.string)
    }
    
    func showUpdateAlert() {
        let cancelDate = UserDefaults.standard.integer(forKey: AppStorageKey.updateAlert.string)
        if cancelDate == 0 {
            isShowUpdateAlert = true
            return
        }
        
        if let nowDateInt = Int(dateFormatter.string(from: Date.now)) {
            isShowUpdateAlert = cancelDate < nowDateInt
        }
    }
    
    func requestAppStoreVersion() -> Bool {
        let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"]! as! String
        
        guard let bundelId = Bundle.main.bundleIdentifier else {
            return false
        }
        guard let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(bundelId)") else {
            return false
        }
        
        guard let data = try? Data(contentsOf: url) else {
            return false
        }
        
        guard let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            return false
        }
        
        let results = json["results"] as? [[String: Any]]
        let appStoreVersion = (results?[0]["version"] as? String) ?? "1.0"
        
        return appStoreVersion > version
    }
    
    func goToAppStore() {
        if let url = URL(string: "itms-apps://itunes.apple.com/kr/app/apple-store/id1624912168") {
            UIApplication.shared.open(url, options: [:]) { success in
                if success {
                    exit(0)
                }
            }
        }
    }
}
