//
//  MakeMemojiCardView.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/04/27.
//

import SwiftUI
import PhotosUI
//import CloudKit

struct MakeMemojiCardView: View {
    @AppStorage(AppStorageKey.userName.string) private var userName = ""
    @AppStorage(AppStorageKey.userSession.string) private var userSession = "Morning"
    @AppStorage(AppStorageKey.saveCount.string) private var saveCount: Int = 0
    @AppStorage(AppStorageKey.cardList.string) private var cardInfoList: Data = Data()
    @AppStorage(AppStorageKey.token.string) private var token: String = ""
    
    // @SceneStorage -> ipad 에서 나옴
    
    var isFirst: Bool
    var uploadMethodArray = ["사진", "미모지 스티커"]
    
    @State private var uploadMethod: String = "사진"
    @State private var picker: Bool = false
    @State private var selectedImage: UIImage = UIImage()
    @State private var selectedMemoji: UIImage = UIImage()
    @State private var isSelecteImage: Bool = false
    @State private var isUploading: Bool = false
    @State private var korean: String = "#"
    @State private var english: String = "#"
    @State private var showAlert = false
    @State private var progressValue = 0.0
    
    @FocusState private var focusedField: Bool
    @Environment(\.dismiss) var dismiss
    
    func createMemojiModel() -> MemojiCard{
        let memojiCard = MemojiCard(name: self.userName,
                                    session: self.userSession,
                                    isFirst: self.isFirst,
                                    isMyCard: true,
                                    imageData: (self.uploadMethod == "사진" ? self.selectedImage : self.selectedMemoji).pngData() ?? Data(),
                                    kor: self.korean.replacingOccurrences(of: " ", with: "_"),
                                    eng: self.english.replacingOccurrences(of: " ", with: "_"),
                                    saveCount: self.saveCount,
                                    token: self.token)
        return memojiCard
    }
    
    func saveData(memojiCard: MemojiCard) {
        var memojiList = JsonManager.shared.jsonDecoder(decodingData: self.cardInfoList)
        memojiList.append(memojiCard)
        self.cardInfoList = JsonManager.shared.jsonEncoder(ecodingData: memojiList)
        self.saveImageToStorage(memojiModel: memojiCard) { snapshot in
            let percentComplete = Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
            if percentComplete == 1.0 {
                self.saveCount += 1
                self.dismiss()
            }
        }
    }
    
    init(isFirst: Bool) {
        self.isFirst = isFirst
        UITextField.appearance().allowsEditingTextAttributes = true
        UITextView.appearance().allowsEditingTextAttributes = true
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                Picker("미모지 업로드 방식", selection: self.$uploadMethod) {
                    ForEach(self.uploadMethodArray, id: \.self) { uploadMethod in
                        Text(uploadMethod)
                    }
                }
                .pickerStyle(.segmented)
                .compositingGroup()
                .padding(.horizontal)
                
                VStack {
                    if self.uploadMethod == "사진" {
                        Text("모두가 서비스를 정상적으로 이용할 수 있도록\n미모지만 업로드 해주세요.")
                            .font(.caption)
                        Button {
                            self.picker.toggle()
                        } label: {
                            if self.isSelecteImage {
                                Image(uiImage: self.selectedImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(minWidth: 100, maxWidth: .infinity, minHeight: 100, maxHeight: .infinity)
                                    .aspectRatio(1, contentMode: .fit)
                                    .cornerRadius(20)
                                    .clipped()
                            } else {
                                Text ("Selecte Image")
                                    .font(.headline)
                                    .frame(minWidth: 100, maxWidth: .infinity, minHeight: 100, maxHeight: .infinity)
                                    .aspectRatio(1, contentMode: .fit)
                            }
                            
                        }
                        .overlay {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(lineWidth: 1)
                                .foregroundColor(Color(red: 200/255, green: 200/255, blue: 200/255))
                        }
                        .sheet(isPresented: self.$picker) {
                            ImagePicker(images: self.$selectedImage, picker: self.$picker, isSelecteImage: self.$isSelecteImage)
                        }
                        .onAppear {
                            self.selectedMemoji = UIImage()
                        }
                        .padding(.horizontal, 40)
                    } else {
                        VStack {
                            Text("미모지 스티커를 1개만 입력해주세요.\n2개 이상 입력시 등록이 불가합니다.")
                                .font(.caption)
                            MemojiTextView(selectedMemoji: self.$selectedMemoji, isSelecteImage: self.$isSelecteImage)
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
                        .onAppear {
                            self.isSelecteImage = false
                            self.selectedImage = UIImage()
                        }
                    }
                }
                
                
                VStack {
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
                                .focused(self.$focusedField)
                        }
                        .padding(.leading, 15)
                        Divider()
                    }
                    
                    VStack(spacing: 8) {
                        HStack(spacing: 5) {
                            Text("영어문구    ")
                            TextField("#으로 시작해주세요", text: self.$english)
                                .focused(self.$focusedField)
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
                        if self.korean.count > 1 && self.english.count > 1 && self.isSelecteImage {
                            self.focusedField = false
                            self.showAlert.toggle()
                        }
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15, style: .circular)
                                .fill(.tint)//Color("MainColor"))
                            if self.isUploading {
                                ProgressView(value: self.progressValue)
                                    .progressViewStyle(.circular)
                            } else {
                                Text("등록하기")
                                    .font(.title)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .disabled(self.isUploading)
                    .frame(height: 60)
                    .alert("저장하시겠습니까?", isPresented: self.$showAlert) {
                        Button("No", role: .cancel) { }
                        Button("Yes", role: .none){
                            self.isUploading = true
                            let memojiModel = createMemojiModel()
                            self.saveData(memojiCard: memojiModel)
                        }
                    } message: {
                        Text("저장 후 삭제가 가능합니다.")
                    }
                }
                .padding()
            }
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
                            if let error = err {
                                debugPrint(error)
                            }
                            return
                        }
                        if let uiImage = selectedImage as? UIImage {
                            self.parent.images = uiImage
                            self.parent.isSelecteImage = true
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
        textView.backgroundColor = .clear
        textView.returnKeyType = .done
        textView.delegate = context.coordinator
        return textView
    }
    
    func updateUIView(_ textView: UITextView, context: Context) {
        
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
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let character = text.first, character.isNewline {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        var nsTextAttachmentCount: [NSTextAttachment] = []
        textView.attributedText.enumerateAttribute(NSAttributedString.Key.attachment, in: NSRange(location: 0, length: textView.attributedText.length)) { value, range, _ in
            if value is NSTextAttachment {
                if let attachment = (value as? NSTextAttachment) {
                    nsTextAttachmentCount.append(attachment)
                }
            }
        }
        if nsTextAttachmentCount.count == 1 {
            if let attachment = nsTextAttachmentCount.first {
                if let image = attachment.image {
                    self.textView.selectedMemoji = image
                    self.textView.isSelecteImage = true
                }
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
