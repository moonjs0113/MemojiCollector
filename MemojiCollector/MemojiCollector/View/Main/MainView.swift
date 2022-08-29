
//
//  MainView.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/04/27.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel: MainViewModel = MainViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                GridCardView(searchText: self.$viewModel.searchText)
                VStack{
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            self.viewModel.isShowMyPage.toggle()
                        } label: {
                            Image(systemName: "person.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.white)
                                .background {
                                    Circle()
                                        .fill(.tint)
                                        .shadow(color: .gray.opacity(0.5), radius: 3, x: 1, y: 2)
                                        .frame(width: 60, height: 60)
                                }
                        }
                        .padding([.bottom, .trailing], 50)
                        .sheet(isPresented: self.$viewModel.isShowMyPage) {
                            MyPageButton()
                        }
                        .sheet(isPresented: $viewModel.isShowGuideView) {
                            GuideView()
                        }
                        .onAppear {
                            if UserDefaultManager.isFirstUser {
                                viewModel.isShowGuideView.toggle()
                            }
                            if viewModel.requestAppStoreVersion() {
                                viewModel.showUpdateAlert()
                            }
                        }
                    }
                }
            }
            .alert("업데이트", isPresented: $viewModel.isShowUpdateAlert) {
                Button("취소") {
                    viewModel.setCancelUpdateDate()
                }
                
                Button("확인") {
                    viewModel.goToAppStore()
                }
            } message: {
                Text("최신버전이 아닙니다.\n업데이트 하시겠습니까?\n확인을 누르면 앱스토어로 이동합니다.")
            }
            .navigationBarItems(trailing:
                                    HStack {
                Button {
                    self.viewModel.isShowGuideView = true
                } label: {
                    Image(systemName: "questionmark.circle")
                }
                NavigationLink {
                    SettingView()
                } label: {
                    Image(systemName: "gear")
                }
            }
            )
            .navigationTitle("Memoji Collector")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: self.$viewModel.searchText, placement: .automatic)
        }
    }
}

extension MainView {
    @ViewBuilder
    func MyPageButton() -> some View{
        if let _ = UserDefaultManager.userID {
            MyMemojiView()
        } else {
            RegisterUserView(isShowMyPage: self.$viewModel.isShowMyPage)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
