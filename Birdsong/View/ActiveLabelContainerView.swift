//
//  ActiveLabelContainerView.swift
//  Birdsong
//
//  Created by Jacob Clayden on 18/11/2019.
//  Copyright © 2019 JacobCXDev. All rights reserved.
//

import UIKit
import ActiveLabel
import TinyConstraints

class ActiveLabelContainerView: UIView {
    public let activeLabel = ActiveLabel()
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: frame.size.width, height: activeLabel.intrinsicContentSize.height)
    }
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        addSubview(activeLabel)
        activeLabel.edgesToSuperview()
    }
    
}
