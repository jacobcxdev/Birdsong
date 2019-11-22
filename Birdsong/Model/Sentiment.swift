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
    
    var state: String {
        switch self {
        case .positive:
            return "+ve"
        case .neutral:
            return "neutral"
        case .negative:
            return "−ve"
        default:
            return "null"
        }
    }
    
    var image: AnyView {
        switch self {
        case .positive:
            return AnyView(Image(systemName: "hand.thumbsup.fill"))
        case .neutral:
            return AnyView(Image(systemName: "minus"))
        case .negative:
            return AnyView(Image(systemName: "hand.thumbsdown.fill"))
        default:
            return AnyView(Arrow(size: 100, direction: .down))
        }
    }
    
    var colour: Color {
        switch self {
        case .positive:
            return .init("positive")
        case .neutral:
            return .init("neutral")
        case .negative:
            return .init("negative")
        default:
            return .clear
        }
    }
}
