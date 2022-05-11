//
//  SelectGroupView.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/05/12.
//

import SwiftUI

struct SelectGroupView: View {
    @AppStorage(AppStorageKey.groupList.string) private var groupList: Data = Data()
    @StateObject var viewModel: MemojiDetaillViewModel = MemojiDetaillViewModel()
    @State var selections: [String] = []
    var memojiCard: MemojiCard
    @Environment(\.dismiss) var dismiss
    
    init(memojiCard: MemojiCard, selections: [String]) {
        self.memojiCard = memojiCard
        self.selections = selections
    }
    
    var body: some View {
        List {
            let groupList = JsonManager.shared.jsonToStringDecoder(decodingData: self.groupList)
            ForEach(groupList, id: \.self) { groupName in
                MultipleSelectionRow(title: groupName, isSelected: self.selections.contains(groupName)) {
                    if self.selections.contains(groupName) {
                        self.selections.removeAll(where: { $0 == groupName })
                    } else {
                        self.selections.append(groupName)
                    }
                }
            }
        }
        .navigationBarItems(trailing:
                                HStack {
            Button {
                self.viewModel.memojiCard.group = self.selections
                self.viewModel.editMemojiDescription()
                self.dismiss()
            } label: {
                Text("저장")
            }
        }
        )
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
        SelectGroupView(memojiCard: MemojiCard(token: ""), selections: [])
    }
}
