//
//  GroupViewModel.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/05/16.
//

import Foundation
import SwiftUI

class GroupViewModel: ObservableObject, AlertDelegate {
    @AppStorage(AppStorageKey.groupList.string) var groupList: Data = Data()
    @Published var showAlert = false
    @Published private var groupName = ""
    
    func deleteGroup(groupName: String) {
        var groupList = JsonManager.shared.jsonToGroupDecoder(decodingData: self.groupList)
        groupList.removeAll { $0.name == groupName }
        self.groupList = JsonManager.shared.groupToJsonEncoder(ecodingData: groupList)
    }
    
    func addGroupName(groupName: String, bufferName: String) {
        var groupList = JsonManager.shared.jsonToGroupDecoder(decodingData: self.groupList)
        if !groupList.map({$0.name}).contains(groupName) {
            if bufferName == "" {
                groupList.append(Group(name: groupName))
            } else {
                if let bufferIndex = groupList.map({$0.name}).firstIndex(of: bufferName) {
                    groupList[bufferIndex].name = groupName
                }
            }
        }

        self.groupList = JsonManager.shared.groupToJsonEncoder(ecodingData: groupList)
        self.showAlert = false
        self.groupName = ""
    }

    func hideAlertView() {
        self.showAlert = false
    }
    
    func getGroupName() -> String {
        return self.groupName
    }
    
    func editGroupName(groupName: String) {
        self.groupName = groupName
        self.showAlert.toggle()
    }
}
