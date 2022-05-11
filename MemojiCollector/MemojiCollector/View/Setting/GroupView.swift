//
//  GroupView.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/05/11.
//

import SwiftUI

struct GroupView: View, AlertDelegate {
    @AppStorage(AppStorageKey.groupList.string) private var groupList: Data = Data()
    @State private var showAlert = false
    @State private var groupName = ""
    
    func deleteGroup(groupName: String) {
        var groupList = JsonManager.shared.jsonToStringDecoder(decodingData: self.groupList)
        groupList.removeAll { $0 == groupName }
        self.groupList = JsonManager.shared.stringToJsonEncoder(ecodingData: groupList)
    }
    
    func addGroupName(groupName: String, bufferName: String) {
        var groupList = JsonManager.shared.jsonToStringDecoder(decodingData: self.groupList)
        if !groupList.contains(groupName) {
            if bufferName == "" {
                groupList.append(groupName)
            } else {
                if let bufferIndex = groupList.firstIndex(of: bufferName) {
                    // 미모지 카드에 등록된 그룹 변경해줘야함
                    groupList.remove(at: bufferIndex)
                    groupList.insert(groupName, at: bufferIndex)
                }
            }
        }

        self.groupList = JsonManager.shared.stringToJsonEncoder(ecodingData: groupList)
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
    
    var body: some View {
        ZStack {
            List {
                let groupList = JsonManager.shared.jsonToStringDecoder(decodingData: self.groupList)
                ForEach(groupList, id: \.self) { groupName in
                    Text(groupName)
                        .swipeActions {
                            Button(role: .destructive) {
                                withAnimation {
                                    self.deleteGroup(groupName: groupName)
                                }
                            } label: {
                                Text("삭제")
                            }
                            Button() {
                                withAnimation {
                                    self.editGroupName(groupName: groupName)
                                }
                            } label: {
                                Text("편집")
                            }
                        }
                }
            }
            if self.showAlert {
                AlertView(alertDelegate: self)
            }
        }
        .navigationBarItems(trailing:
                                Button{
            self.showAlert.toggle()
        } label: {
            Image(systemName: "plus")
        }
        )
        .navigationTitle("그룹")
    }
}

protocol AlertDelegate {
    func addGroupName(groupName: String, bufferName: String)
    func hideAlertView()
    func getGroupName() -> String
}

struct AlertView: UIViewControllerRepresentable {
    let alertDelegate: AlertDelegate
    
    func makeUIViewController(context: Context) -> AlertViewController {
        return AlertViewController(alertDelegate: self.alertDelegate)
    }
    
    func updateUIViewController(_ uiViewController: AlertViewController, context: UIViewControllerRepresentableContext<AlertView>) {
        
    }
}

class AlertViewController: UIViewController {
    let alertDelegate: AlertDelegate
    let bufferName: String
    
    init(alertDelegate: AlertDelegate) {
        self.alertDelegate = alertDelegate
        self.bufferName = alertDelegate.getGroupName()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func presentAlertController() {
        let title = (self.bufferName == "") ? "그룹 추가" : "그룹 수정"
        let message = (self.bufferName == "") ? "추가할 그룹명을 입력해주세요.\n이미 그룹이 존재하는 경우 추가되지 않습니다." : "추가할 그룹명을 입력해주세요.\n이미 그룹이 존재하는 경우 수정되지 않습니다."
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField{ (textField) in
            textField.placeholder = "그룹명"
            textField.textColor = .black
            textField.text = self.bufferName
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            withAnimation {
                self.alertDelegate.hideAlertView()
            }
        }
        let saveAction = UIAlertAction(title: "Add", style: .default) { _ in
            if let groupName = alertController.textFields![0].text {
                self.alertDelegate.addGroupName(groupName: groupName, bufferName: self.bufferName)
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.presentAlertController()
    }
}

struct GroupView_Previews: PreviewProvider {
    static var previews: some View {
        GroupView()
    }
}
