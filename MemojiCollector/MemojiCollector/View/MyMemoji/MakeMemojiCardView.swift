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
    var isFirst: Bool
    
    @State private var isUploading: Bool = false
    @State private var showAlert = false
    @State private var progressValue = 0.0
    
    @FocusState private var focusedField: Bool
    
    @Environment(\.dismiss) var dismiss
    
    init(isFirst: Bool) {
        self.isFirst = isFirst
        UITextField.appearance().allowsEditingTextAttributes = true
        UITextView.appearance().allowsEditingTextAttributes = true
    }
    
    var body: some View {
        
        ScrollView {
            VStack(spacing: 25) {
                VStack {
                    Text("1개의 미모지 스티커만 입력가능합니다.")
                        .font(.caption)
                    MemojiTextView(selectedMemoji: self.$viewModel.selectedMemoji,
                                   isSelecteImage: self.$viewModel.isSelecteImage)
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
                    Button {
                        if let url = URL(string: "App-prefs:General&path=Keyboard") {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    } label: {
                        Text("미모지콘 스티커 활성화하기")
                            .font(.subheadline)
                    }
                }
                .padding(.top, 50)
                
                VStack {
                    VStack(spacing: 8) {
                        HStack(spacing: 5) {
                            Text("닉네임        ")
                            TextField("NickName", text: self.$viewModel.userName)
                                .disabled(true)
                        }
                        .padding(.leading, 15)
                        Divider()
                    }
                    
                    VStack(spacing: 8) {
                        HStack(spacing: 5) {
                            Text("첫번째문구  ")
                            ZStack(alignment: .leading) {
                                if self.viewModel.korean.count == 1 {
                                    Text("#최대 20자까지 가능합니다.")
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.leading)
                                        .frame(alignment: .leading)
                                        .minimumScaleFactor(0.1)
                                }
                                TextField("#으로 시작해주세요", text: self.$viewModel.korean)
                                    .onChange(of: self.viewModel.korean) { newValue in
                                        self.viewModel.firstTextCheck(newValue: newValue)
                                    }
                                    .focused(self.$focusedField)
                            }
                            
                        }
                        .padding(.leading, 15)
                        Divider()
                    }
                    
                    VStack(spacing: 8) {
                        HStack(spacing: 5) {
                            Text("두번째문구  ")
                            ZStack(alignment: .leading) {
                                if self.viewModel.english.count == 1 {
                                    Text("#최대 20자까지 가능합니다.")
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.leading)
                                        .frame(alignment: .leading)
                                        .minimumScaleFactor(0.1)
                                }
                                TextField("#으로 시작해주세요", text: self.$viewModel.english)
                                    .onChange(of: self.viewModel.english) { newValue in
                                        self.viewModel.secondTextCheck(newValue: newValue)
                                    }
                                    .focused(self.$focusedField)
                            }
                        }
                        .padding(.leading, 15)
                        Divider()
                    }
                    Text("*띄어쓰기는 저장 시 _로 변환됩니다.")
                        .font(.caption)
                    
                    Spacer()
                    Button {
                        if self.viewModel.isEnableRegister() {
                            self.focusedField = false
                            self.showAlert.toggle()
                        }
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 5, style: .circular)
                                .fill(.tint)
                            if self.isUploading {
                                ProgressView(value: self.progressValue)
                                    .progressViewStyle(.circular)
                            } else {
                                Text("등록하기")
                                    .font(.body)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .disabled(self.isUploading || self.viewModel.isEmptySomeData())
                    .frame(height: 60)
                    .alert("저장하시겠습니까?", isPresented: self.$showAlert) {
                        Button("No", role: .cancel) { }
                        Button("Yes", role: .none){
                            self.isUploading = true
                            let memojiModel = self.viewModel.createMemojiModel()
                            self.viewModel.saveData(memojiCard: memojiModel) {
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
                self.viewModel.isFirst = self.isFirst
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(self.isUploading)
        }
        
    }
}

struct MakeMemojiCardView_Previews: PreviewProvider {
    static var previews: some View {
        MakeMemojiCardView(isFirst: true)
    }
}
