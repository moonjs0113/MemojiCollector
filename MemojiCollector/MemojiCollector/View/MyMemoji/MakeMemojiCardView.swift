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
    
    var uploadMethodArray = ["미모지 스티커", "사진",]
    var isFirst: Bool
    
//    @State private var uploadMethod: String = "미모지 스티커"
//    @State private var isShowImagePicker: Bool = false
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
                    MemojiTextView(selectedMemoji: self.$viewModel.selectedMemoji, isSelecteImage: self.$viewModel.isSelecteImage)
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
                }
                
                
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
//                                        self.viewModel.hangulTextCheck(newValue: newValue)
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
//                                        self.viewModel.englishTextCheck(newValue: newValue)
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

struct ImagePicker : UIViewControllerRepresentable {
    func makeCoordinator() -> Coordinator {
        return ImagePicker.Coordinator(parent: self)
    }
    
    @Binding var images : UIImage
    @Binding var picker : Bool
    @Binding var isSelecteImage : Bool
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        let picker = PHPickerViewController(configuration: config)
        config.filter = .images
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
                            if let error = err {
                                debugPrint(error)
                            }
                            return
                        }
                        if let uiImage = selectedImage as? UIImage {
                            DispatchQueue.main.async { [weak self] in
                                self?.parent.images = uiImage
                                self?.parent.isSelecteImage = true
                            }
                        }
                    }
                }
            }
        }
    }
}

protocol MemojiTextViewDelegate {
    func getImageFromTextView(image: UIImage) -> ()
}

struct MemojiTextView: UIViewRepresentable {
    @Binding var selectedMemoji: UIImage
    @Binding var isSelecteImage : Bool
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.centerVerticalText()
        textView.textAlignment = .center
        textView.backgroundColor = .clear
        textView.returnKeyType = .done
        textView.text = "\n\n이곳을 눌러 미모지 스티커를 입력하세요.\n미모지 스티커는 이모티콘 키보드의 가장 왼쪽에 있습니다."
        textView.delegate = context.coordinator
        textView.centerVerticalText()
        return textView
    }
    
    func updateUIView(_ textView: UITextView, context: Context) {
        textView.centerVerticalText()
    }
    
    func makeCoordinator() -> TextViewCoordinator {
        TextViewCoordinator(textView: self)
    }
}

class TextViewCoordinator: NSObject, UITextViewDelegate {
    var textView: MemojiTextView
    init(textView: MemojiTextView) {
        self.textView = textView
    }
    
    func resizingImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let character = text.first, character.isNewline {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textView.centerVerticalText()
        var nsTextAttachmentCount: [NSTextAttachment] = []
        textView.attributedText.enumerateAttribute(NSAttributedString.Key.attachment, in: NSRange(location: 0, length: textView.attributedText.length)) { value, range, _ in
            if value is NSTextAttachment {
                if let attachment = (value as? NSTextAttachment) {
                    nsTextAttachmentCount.append(attachment)
                }
            } else {
                textView.attributedText = NSAttributedString(string: "")
            }
        }
        if nsTextAttachmentCount.count > 0 {
            if let attachment = nsTextAttachmentCount.last {
                if let image = attachment.image {
                    self.textView.selectedMemoji = image
                    self.textView.isSelecteImage = true
                    let newImage = self.resizingImage(image: image, targetSize: textView.frame.size)
                    textView.attributedText = NSAttributedString(attachment: NSTextAttachment(image: newImage))
                }
                textView.endEditing(true)
            }
        } else {
            self.textView.isSelecteImage = false
            self.textView.selectedMemoji = UIImage()
        }
    }
}

struct MakeMemojiCardView_Previews: PreviewProvider {
    static var previews: some View {
        MakeMemojiCardView(isFirst: true)
    }
}
