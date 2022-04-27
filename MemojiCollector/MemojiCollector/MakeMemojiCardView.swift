//
//  MakeMemojiCardView.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/04/27.
//

import SwiftUI
import PhotosUI

struct MakeMemojiCardView: View {
    @AppStorage(AppStorageKey.firstCard.string) private var firstCardInfo = ""
    @AppStorage(AppStorageKey.secondCard.string) private var secondCardInfo = ""
    
    @AppStorage(AppStorageKey.firstCardImage.string) private var firstCardImage = Data()
    @AppStorage(AppStorageKey.secondCardImage.string) private var secondCardImage = Data()
    
    @AppStorage(AppStorageKey.userName.string) private var userName = ""
    @AppStorage(AppStorageKey.userSession.string) private var userSession = "Morning"

    var index: Int
    
    @State private var picker: Bool = false
    @State private var selectedImage: UIImage = UIImage()
    @State private var korean: String = "#"
    @State private var english: String = "#"
    @State private var showAlert = false
    
    @Environment(\.dismiss) var dismiss
    
    func saveData() {
        self.korean = self.korean.replacingOccurrences(of: " ", with: "_")
        self.english = self.english.replacingOccurrences(of: " ", with: "_")
        
        let saveString = "MemojiCollector://?ID=\(self.userName)_\(self.userSession)_\(self.index).png&kor=\(self.korean)&eng=\(self.english)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        let saveImageData = self.selectedImage.pngData() ?? Data()
        
        if self.index == 0 {
            self.firstCardInfo = saveString
            self.firstCardImage = saveImageData
        } else {
            self.secondCardInfo = saveString
            self.secondCardImage = saveImageData
        }
    }
    
    var body: some View {
        VStack(spacing: 25) {
            Image(uiImage: self.selectedImage)
                .resizable()
                .frame(width: 100, height: 100)
                .cornerRadius(20)
            Button("Selected Image") {
                self.picker.toggle()
            }
            .sheet(isPresented: self.$picker) {
                ImagePicker(images: self.$selectedImage, picker: self.$picker)
            }
            
            VStack(spacing: 8) {
                HStack(spacing: 5) {
                    Text("닉네임        ")
                    TextField("NickName", text: self.$userName)
                        .disabled(true)
                }
                .padding(.leading, 15)
                Divider()
            }
            
            VStack(spacing: 8) {
                HStack(spacing: 5) {
                    Text("한글문구    ")
                    TextField("#으로 시작해주세요", text: self.$korean)
                }
                .padding(.leading, 15)
                Divider()
            }
            
            VStack(spacing: 8) {
                HStack(spacing: 5) {
                    Text("영어문구    ")
                    TextField("#으로 시작해주세요", text: self.$english)
                }
                .padding(.leading, 15)
                Divider()
            }
            
            VStack(spacing: 8) {
                HStack(spacing: 5) {
                    Text("Session     ")
                    TextField("NickName", text: self.$userSession)
                        .disabled(true)
                }
                .padding(.leading, 15)
                Divider()
            }
            Text("*띄어쓰기는 저장 시 _로 변환됩니다.")
                .font(.caption)
            
            Spacer()
            Button {
                if self.korean.count > 1 && self.english.count > 1 {
                    self.showAlert.toggle()
                }
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 15, style: .circular)
                        .fill(Color(red: 66/255, green: 234/255, blue: 221/255))
                    Text("등록하기")
                        .font(.title)
                        .foregroundColor(.white)
                }
            }
            .frame(height: 60)
            .alert("저장하시겠습니까?", isPresented: self.$showAlert) {
                Button("No", role: .cancel) { }
                Button("Yes", role: .none){
                    self.saveData()
                    self.dismiss()
                }
            } message: {
                Text("저장 후 삭제가 가능합니다.")
            }
        }
        .padding()
    }
}

struct ImagePicker : UIViewControllerRepresentable {
    func makeCoordinator() -> Coordinator {
        return ImagePicker.Coordinator(parent: self)
    }
    
    @Binding var images : UIImage
    @Binding var picker : Bool
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent :ImagePicker
        
        init(parent : ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            self.parent.picker.toggle()
            
            for img in results {
                if img.itemProvider.canLoadObject(ofClass: UIImage.self){
                    img.itemProvider.loadObject(ofClass: UIImage.self) { (image, err) in
                        guard let selectedImage = image else {
                            print("err ")
                            return
                        }
                        if let uiImage = selectedImage as? UIImage {
                            self.parent.images = uiImage
                        }
                    }
                } else {
                    print("cannot be loaded ")
                }
            }
        }
    }
}

struct MakeMemojiCardView_Previews: PreviewProvider {
    static var previews: some View {
        MakeMemojiCardView(index: 0)
    }
}
