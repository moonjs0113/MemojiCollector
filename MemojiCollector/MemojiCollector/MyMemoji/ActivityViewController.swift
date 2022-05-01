//
//  ActivityViewController.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/04/29.
//

import SwiftUI
import UIKit
import LinkPresentation

struct MemojiActivityViewController: UIViewControllerRepresentable {
    let memojiModel: MemojiCard
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<MemojiActivityViewController>) -> UIActivityViewController {
        
        let controller = UIActivityViewController(activityItems: [ActivityItemSource(), self.memojiModel.urlScheme], applicationActivities: nil)
        
        
        
        
        controller.excludedActivityTypes = [.message,
                                            .mail,
                                            .markupAsPDF,
                                            .saveToCameraRoll,
                                            .assignToContact,
                                            .copyToPasteboard,
                                            .addToReadingList,
                                            .openInIBooks,
                                            .postToFacebook,
                                            .postToFlickr,
                                            .postToTencentWeibo,
                                            .postToTwitter,
                                            .postToVimeo,
                                            .postToWeibo,
                                            .print
        ]
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<MemojiActivityViewController>) {
        
    }
}


class ActivityItemSource: NSObject, UIActivityItemSource {
    var title: String = "Memoji Collector"
    var text: String = "미모지를 보내세요!"
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return self.text
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return self.text
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
        return self.title
    }

    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()
        metadata.title = self.title
        metadata.iconProvider = NSItemProvider(object: UIImage(named: "AppIcon") ?? UIImage())
        metadata.originalURL = URL(fileURLWithPath: self.text)
        return metadata
    }

}
