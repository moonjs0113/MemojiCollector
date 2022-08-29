//
//  MakeMemojiCardView.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/04/27.
//

import SwiftUI
import PhotosUI

struct MakeMemojiCardView: View {
    @ObservedObject var viewModel: MakeMemojiViewModel = MakeMemojiViewModel()
    var isRight: Bool
    
    @State private var isUploading: Bool = false
    @State private var showAlert = false
    @State private var showErrorAlert = false
    @State private var progressValue = 0.0
    
    @FocusState private var focusedField: Bool
    
    @Environment(\.dismiss) var dismiss
    
    init(isRight: Bool) {
        self.isRight = isRight
        UITextField.appearance().allowsEditingTextAttributes = true
        UITextView.appearance().allowsEditingTextAttributes = true
    }
    
    var body: some View {
        
        ScrollView {
            VStack(spacing: 25) {
                VStack {
                    Text("1개의 미모티콘 스티커만 입력가능합니다.")
                        .font(.caption)
                    MemojiTextView(selectedMemoji: $viewModel.selectedMemoji,
                                   isSelecteImage: $viewModel.isSelecteImage)
                        .frame(minWidth: 100, maxWidth: .infinity, minHeight: 100, maxHeight: .infinity)
                        .aspectRatio(1, contentMode: .fit)
                        .cornerRadius(20)
                        .clipped()
                        .overlay {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(lineWidth: 1)
                                .foregroundColor(Color(red: 200/255, green: 200/255, blue: 200/255))
                        }
                        .focused(self.$focusedField)
                        .padding(.horizontal, 50)
                    
                    VStack {
                        Text("\(Image(systemName: "exclamationmark.circle")) 미모티콘 스티커가 보이지 않는다면?")
                            .font(.caption2)
                        Button {
                            if let url = URL(string: "App-prefs:General&path=Keyboard") {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            }
                        } label: {
                            Text("설정에서 활성화하기")
                                .font(.caption)
                        }
                    }
                }
                .padding(.top, 50)
                
                VStack {
                    VStack(spacing: 8) {
                        HStack(spacing: 5) {
                            Text("닉네임        ")
                            TextField("NickName", text: $viewModel.userName)
                                .disabled(true)
                        }
                        .padding(.leading, 15)
                        Divider()
                    }
                    
                    VStack(spacing: 8) {
                        HStack(spacing: 5) {
                            Text("첫번째문구  ")
                            ZStack(alignment: .leading) {
                                if viewModel.firstString.count == 1 {
                                    Text("#최대 20자까지 가능합니다.")
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.leading)
                                        .frame(alignment: .leading)
                                        .minimumScaleFactor(0.1)
                                }
                                TextField("#으로 시작해주세요", text: $viewModel.firstString)
                                    .onChange(of: viewModel.firstString) { newValue in
                                        viewModel.firstTextCheck(newValue: newValue)
                                    }
                                    .focused($focusedField)
                            }
                            
                        }
                        .padding(.leading, 15)
                        Divider()
                    }
                    
                    VStack(spacing: 8) {
                        HStack(spacing: 5) {
                            Text("두번째문구  ")
                            ZStack(alignment: .leading) {
                                if viewModel.secondString.count == 1 {
                                    Text("#최대 20자까지 가능합니다.")
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.leading)
                                        .frame(alignment: .leading)
                                        .minimumScaleFactor(0.1)
                                }
                                TextField("#으로 시작해주세요", text: $viewModel.secondString)
                                    .onChange(of: viewModel.secondString) { newValue in
                                        viewModel.secondTextCheck(newValue: newValue)
                                    }
                                    .focused($focusedField)
                            }
                        }
                        .padding(.leading, 15)
                        Divider()
                    }
                    Text("*띄어쓰기는 저장 시 _로 변환됩니다.")
                        .font(.caption)
                    
                    Spacer()
                    Button {
                        if viewModel.isEnableRegister() {
                            focusedField = false
                            showAlert.toggle()
                        }
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 5, style: .circular)
                                .fill(.tint)
                            if isUploading {
                                ProgressView(value: progressValue)
                                    .progressViewStyle(.circular)
                            } else {
                                Text("등록하기")
                                    .font(.body)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .disabled(isUploading || viewModel.isEmptySomeData())
                    .frame(height: 60)
                    .alert("저장하시겠습니까?", isPresented: $showAlert) {
                        Button("No", role: .cancel) { }
                        Button("Yes", role: .none){
                            isUploading = true
                            viewModel.registerCardID { error in
                                if let _ = error {
                                    showErrorAlert.toggle()
                                    return
                                }
                                self.dismiss()
                            }
                        }
                    } message: {
                        Text("저장 후 삭제가 가능합니다.")
                    }
                }
                .padding()
            }
            .onAppear {
                viewModel.isRight = self.isRight
            }
            .alert("저장 실패", isPresented: $showErrorAlert) {
                Button("확인", role: .none) {
                    
                }
            } message: {
                Text("저장에 실패했습니다.\n 잠시 후 다시 시도해주세요.")
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(isUploading)
        }
        
    }
}

struct MakeMemojiCardView_Previews: PreviewProvider {
    static var previews: some View {
        MakeMemojiCardView(isRight: true)
    }
}
