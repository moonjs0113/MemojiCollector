//
//  SelectGroupView.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/05/12.
//

import SwiftUI

struct SelectGroupView: View {
    @AppStorage(AppStorageKey.groupList.string) private var groupList: Data = Data()
    var memojiCard: MemojiCard
    
    @EnvironmentObject var groupFilter: GroupFilter
    @Environment(\.dismiss) var dismiss
    
    init(memojiCard: MemojiCard) {
        self.memojiCard = memojiCard
    }
    
    var body: some View {
        List {
            var groupList = JsonManager.shared.jsonToGroupDecoder(decodingData: self.groupList)
            ForEach(Array(groupList.enumerated()), id: \.1.name) { index, group in
                MultipleSelectionRow(title: group.name, isSelected: group.memojiCardList.contains(self.memojiCard)) {
                    if group.memojiCardList.contains(self.memojiCard) {
                        groupList[index].memojiCardList.removeAll(where: { $0.urlString == self.memojiCard.urlString  })
                    } else {
                        groupList[index].memojiCardList.append(self.memojiCard)
                    }
//                    self.groupFilter.groupList = groupList

                    self.groupList = JsonManager.shared.groupToJsonEncoder(ecodingData: groupList)
                }
            }
        }
        .onDisappear {
            let groupList = JsonManager.shared.jsonToGroupDecoder(decodingData: self.groupList).filter { group in
                self.groupFilter.groupList.map({$0.name}).contains(group.name)
            }
            self.groupFilter.groupList = groupList
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MultipleSelectionRow: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: self.action) {
            HStack {
                Text(self.title)
                if self.isSelected {
                    Spacer()
                    Image(systemName: "checkmark")
                }
            }
        }
    }
}

struct SelectGroupView_Previews: PreviewProvider {
    static var previews: some View {
        SelectGroupView(memojiCard: MemojiCard(token: ""))
    }
}
