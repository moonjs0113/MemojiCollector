//
//  QRCodeView.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/06/24.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct QRCodeView: View {
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    let memojiModel: MemojiCard
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State var time = 60
    @State var qrImage = UIImage()
//    @State var timerRunning = false
    
    func generateQRCode() -> UIImage {
        let urlString = self.memojiModel.urlString + "&timeStamp=\(Date.now)"
        let data = Data(urlString.utf8)
        self.filter.setValue(data, forKey: "inputMessage")
        
        guard let qrCodeImage = self.filter.outputImage else {
            return UIImage()
        }
        
        guard let qrCodeCGImage = self.context.createCGImage(qrCodeImage, from: qrCodeImage.extent) else {
            return UIImage()
        }
        
        return UIImage(cgImage: qrCodeCGImage)
    }
    
    var body: some View {
        VStack {
            Text("생성된 QR Code는 1분 동안 사용할 수 있습니다.")
            Text(self.time == 60 ? "1:00": "0:\(self.time)")
                .onReceive(self.timer) { _ in
                    if self.time == 0 {
                        self.qrImage = self.generateQRCode()
                    }
                    self.time = (self.time > 0) ? (self.time - 1) : 60
                }
            Image(uiImage: self.qrImage)
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .padding()
                .onAppear {
                    self.qrImage = self.generateQRCode()
                }
        }
        
    }
}

struct QRCodeView_Previews: PreviewProvider {
    static var previews: some View {
        QRCodeView(memojiModel: MemojiCard(token: ""))
    }
}
