//
//  ActiveLabelView.swift
//  Birdsong
//
//  Created by Jacob Clayden on 18/11/2019.
//  Copyright © 2019 JacobCXDev. All rights reserved.
//

import SwiftUI
import ActiveLabel

struct ActiveLabelView: UIViewRepresentable {
    @State var text: String
    @State var textColor: UIColor = .label
    @State var font: UIFont?
    @State var numberOfLines: Int = 0
    @State var enabledTypes: [ActiveType] = [.mention, .hashtag, .url]
    @State var urlMaximumLength: Int?
    @State var mentionColor: UIColor = .blue
    @State var mentionSelectedColor: UIColor?
    @State var hashtagColor: UIColor = .blue
    @State var hashtagSelectedColor: UIColor?
    @State var URLColor: UIColor = .blue
    @State var URLSelectedColor: UIColor?
    @State var lineSpacing: CGFloat = 0
    @State var minimumLineHeight: CGFloat = 0
    @State var highlightFontName: String?
    @State var highlightFontSize: CGFloat?
    @State var delegate: ActiveLabelDelegate?
    @State var handleMentionTap: (String) -> Void
    @State var handleHashtagTap: (String) -> Void
    @State var handleURLTap: (URL) -> Void
    
    func makeUIView(context: Context) -> ActiveLabelContainerView {
        ActiveLabelContainerView()
    }
    
    func updateUIView(_ uiView: ActiveLabelContainerView, context: Context) {
        uiView.activeLabel.text = text
        uiView.activeLabel.textColor = textColor
        if let font = font {
            uiView.activeLabel.font = font
        }
        uiView.activeLabel.numberOfLines = numberOfLines
        uiView.activeLabel.enabledTypes = enabledTypes
        uiView.activeLabel.urlMaximumLength = urlMaximumLength
        uiView.activeLabel.mentionColor = mentionColor
        uiView.activeLabel.mentionSelectedColor = mentionSelectedColor
        uiView.activeLabel.hashtagColor = hashtagColor
        uiView.activeLabel.hashtagSelectedColor = hashtagSelectedColor
        uiView.activeLabel.URLColor = URLColor
        uiView.activeLabel.URLSelectedColor = URLSelectedColor
        uiView.activeLabel.lineSpacing = lineSpacing
        uiView.activeLabel.minimumLineHeight = minimumLineHeight
        uiView.activeLabel.highlightFontName = highlightFontName
        uiView.activeLabel.highlightFontSize = highlightFontSize
        uiView.activeLabel.delegate = delegate
        uiView.activeLabel.handleMentionTap { mention in
            self.handleMentionTap(mention)
        }
        uiView.activeLabel.handleHashtagTap { hashtag in
            self.handleHashtagTap(hashtag)
        }
        uiView.activeLabel.handleURLTap { url in
            self.handleURLTap(url)
        }
    }
}
