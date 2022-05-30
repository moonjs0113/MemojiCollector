//
//  FilterGroupView.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/05/16.
//

import SwiftUI

struct FilterGroupView: View {
    @StateObject var groupFilter: GroupFilter
//    @AppStorage(AppStorageKey.groupList.string) private var groupList: Data = Data()
    @Binding var selectedGroupList: [Group]
    
    var body: some View {
        List {
            let groupList = JsonManager.shared.jsonToGroupDecoder(decodingData: self.groupFilter.groupListData)
            ForEach(groupList, id: \.self.name) { group in
                MultipleSelectionRow(title: group.name, isSelected: self.selectedGroupList.map({$0.name}).contains(group.name)) {
                    if self.selectedGroupList.map({$0.name}).contains(group.name) {
                        self.selectedGroupList.removeAll{$0.name == group.name}
                    } else {
                        self.selectedGroupList.append(group)
                    }
                }
                
//                MultipleSelectionRow(title: group.name, isSelected: self.groupFilter.selectedGroupList.map({$0.id}).contains(group.id)) {
//                    if self.groupFilter.selectedGroupList.map({$0.id}).contains(group.id) {
//                        self.groupFilter.selectedGroupList.removeAll{$0.id == group.id}
//                    } else {
//                        self.groupFilter.selectedGroupList.append(group)
//                    }
//                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

//struct FilterGroupView_Previews: PreviewProvider {
//    static var previews: some View {
//        FilterGroupView()
//    }
//}
