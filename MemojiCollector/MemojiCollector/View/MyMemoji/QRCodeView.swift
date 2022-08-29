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
    
    func generateQRCode() -> UIImage {
        let urlString = memojiModel.cardID.uuidString + "&timeStamp=\(Date.now)"
        let data = Data(urlString.utf8)
        self.filter.message = data
        self.filter.correctionLevel = "L"
        let transform = CGAffineTransform(scaleX: 5, y: 5)
            
        guard let qrCodeImage = self.filter.outputImage?.transformed(by: transform) else {
            return UIImage()
        }
        
        guard let qrCodeCGImage = self.context.createCGImage(qrCodeImage, from: qrCodeImage.extent) else {
            return UIImage()
        }
        
        return UIImage(cgImage: qrCodeCGImage)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("QR Code로 공유")
                .padding(.vertical, 25)
            
            Text("생성된 QR Code는 1분 동안 사용할 수 있습니다.")
            Text(self.time == 60 ? "1:00": "0:\(String(format: "%02d", self.time))")
                .onReceive(self.timer) { _ in
                    if self.time == 1 {
                        self.qrImage = self.generateQRCode()
                    }
                    self.time = (self.time > 1) ? (self.time - 1) : 60
                }
            Image(uiImage: self.qrImage)
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .padding(.horizontal, 60)
                .onAppear {
                    self.qrImage = self.generateQRCode()
                }
            
            Spacer()
        }
        .padding()
        
    }
}

struct QRCodeView_Previews: PreviewProvider {
    static var previews: some View {
        QRCodeView(memojiModel: MemojiCard(token: ""))
    }
}
