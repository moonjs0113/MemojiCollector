
//
//  MainView.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/04/27.
//

import SwiftUI

struct MainView: View {
    @State private var searchText = ""
    @State private var isShowMyPage = false
    @State private var isShowGuide = false
    @AppStorage(AppStorageKey.isUserNameRegister.string) private var isUserNameRegister: Bool = true
    @AppStorage(AppStorageKey.firstGuide.string) private var firstGuide: Bool = true
    
    func requestAppStoreVersion() {
        let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"]! as! String
        
        guard let bundelId = Bundle.main.bundleIdentifier else {
            return
        }
        guard let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(bundelId)") else {
            return
        }
        
        guard let data = try? Data(contentsOf: url) else {
            return
        }
        
        guard let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            return
        }
        
        let results = json["results"] as? [[String: Any]]
        let appStoreVersion = (results?[0]["version"] as? String) ?? "1.0"
        
//        if appStoreVersion > version {
//            self.appVersionUpdateAlert()
//        } else {
//            self.getLoginData()
//        }
        print("Current Version: \(version)")
        print("App Store Version: \(appStoreVersion)")
    }
    
    @ViewBuilder
    func goToMyMemojiView() -> some View{
        if self.isUserNameRegister {
            RegisterUserView(isShowMyPage: self.$isShowMyPage)
        } else {
            MyMemojiView()
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                GridCardView(searchText: self.$searchText)
                
                VStack{
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            self.isShowMyPage.toggle()
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
                        .sheet(isPresented: self.$isShowMyPage) {
                            self.goToMyMemojiView()
                        }
                        .sheet(isPresented: $isShowGuide) {
                            GuideView()
                        }
//                        .fullScreenCover(isPresented: $isShowGuide) {
//                            GuideView()
//                                .ignoresSafeArea(.all, edges: .top)
//                        }
                        .onAppear {
                            if firstGuide {
                                firstGuide = false
                                isShowGuide.toggle()
                            }
                            DispatchQueue.global().async {
                                self.requestAppStoreVersion()
                            }
                        }
                    }
                }
            }
            .navigationBarItems(trailing:
                                    HStack {
                Button {
                    self.isShowGuide = true
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
            .searchable(text: self.$searchText, placement: .automatic)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
