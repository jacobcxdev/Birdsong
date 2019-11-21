//
//  Sentiment.swift
//  Birdsong
//
//  Created by Jacob Clayden on 18/11/2019.
//  Copyright © 2019 JacobCXDev. All rights reserved.
//

import SwiftUI

enum Sentiment {
    case positive
    case neutral
    case negative
    case null
    
    var currentSentiment: (Image, Color) {
        switch self {
        case .positive:
            return (.init(systemName: "hand.thumbsup.fill"), .init("positive"))
        case .neutral:
            return (.init(systemName: "minus"), .init("neutral"))
        case .negative:
            return (.init(systemName: "hand.thumbsdown.fill"), .init("negative"))
        default:
            return (.init(systemName: "arrow.down"), .clear)
        }
    }
}
