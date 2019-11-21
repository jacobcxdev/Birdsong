//
//  KeyboardGuardian.swift
//  Birdsong
//
//  Created by Jacob Clayden on 18/11/2019.
//  Copyright © 2019 JacobCXDev. All rights reserved.
//

import SwiftUI
import Combine

final class KeyboardGuardian: ObservableObject {
    public var rects: Array<CGRect>
    public var keyboardRect: CGRect = CGRect()
    public var keyboardIsHidden = true
    
    @Published var slide: CGFloat = 0
    
    var showField: Int = 0 {
        didSet {
            updateSlide()
        }
    }
    
    init(textFieldCount: Int) {
        self.rects = Array<CGRect>(repeating: CGRect(), count: textFieldCount)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardDidHide(notification:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    func removeObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyBoardWillShow(notification: Notification) {
        if keyboardIsHidden {
            keyboardIsHidden = false
            if let rect = notification.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? CGRect {
                keyboardRect = rect
                updateSlide()
            }
        }
    }
    
    @objc func keyBoardDidHide(notification: Notification) {
        keyboardIsHidden = true
        updateSlide()
    }
    
    func updateSlide() {
        if keyboardIsHidden {
            slide = 0
        } else {
            let tfRect = self.rects[self.showField]
            let diff = keyboardRect.minY - tfRect.maxY
            
            if diff > 0 {
                slide += diff
            } else {
                slide += min(diff, 0)
            }
            
        }
    }
}

struct GeometryGetter: View {
    @Binding var rect: CGRect
    
    var body: some View {
        GeometryReader { geometry in
            Group { () -> AnyView in
                DispatchQueue.main.async {
                    self.rect = geometry.frame(in: .global)
                }
                
                return AnyView(Color.clear)
            }
        }
    }
}


// - MARK: Instructions

/*
 
// Add the following property to the view struct:

@ObservedObject private var kGuardian = KeyboardGuardian(textFieldCount: 1)
 

// Add the following parameter to the text field:

onCommit: {
    self.kGuardian.slide = 0
}


// Add the following modifiers to the text field:

.background(GeometryGetter(rect: $kGuardian.rects[0]))
.offset(y: kGuardian.slide)
.animation(.spring())
.onAppear {
    self.kGuardian.addObserver()
}
.onDisappear {
    self.kGuardian.removeObserver()
}

*/