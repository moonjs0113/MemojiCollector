//
//  GroupView.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/05/11.
//

import SwiftUI

struct GroupView: View{
    @StateObject var viewModel: GroupViewModel = GroupViewModel()
    
    var body: some View {
        ZStack {
            List {
                let groupList = JsonManager.shared.jsonToGroupDecoder(decodingData: self.viewModel.groupList)
                ForEach(groupList, id: \.self) { group in
                    Text(group.name)
                        .swipeActions {
                            Button(role: .destructive) {
                                withAnimation {
                                    self.viewModel.deleteGroup(groupName: group.name)
                                }
                            } label: {
                                Text("삭제")
                            }
                            Button() {
                                withAnimation {
                                    self.viewModel.editGroupName(groupName: group.name)
                                }
                            } label: {
                                Text("편집")
                            }
                        }
                }
            }
            if self.viewModel.showAlert {
                AlertView(alertDelegate: self.viewModel)
            }
        }
        .navigationBarItems(trailing: Button{
            self.viewModel.showAlert.toggle()
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
        let saveAction = UIAlertAction(title: (self.bufferName == "") ? "Add" : "Edit", style: .default) { _ in
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
