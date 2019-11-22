//
//  Arrow.swift
//  Birdsong
//
//  Created by Jacob Clayden on 22/11/2019.
//  Copyright © 2019 JacobCXDev. All rights reserved.
//

import SwiftUI

struct Arrow: View {
    @State var size: CGFloat
    @State var direction: Direction
    
    enum Direction: String {
        case up = "up"
        case down = "down"
        case left = "left"
        case right = "right"
    }
    
    var body: some View {
        Image(systemName: "arrow.\(direction)")
            .font(.system(size: size))
            .shadow(color: Color(.systemBackground).opacity(0.5), radius: 10)
    }
}

struct Arrow_Previews: PreviewProvider {
    static var previews: some View {
        Arrow(size: 100, direction: .down)
    }
}
