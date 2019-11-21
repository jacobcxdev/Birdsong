//
//  Extensions.swift
//  Birdsong
//
//  Created by Jacob Clayden on 18/11/2019.
//  Copyright © 2019 JacobCXDev. All rights reserved.
//

import SwiftUI

extension String {
    func tokenize(_ delimiters: String) -> [String] {
        var output = [String]()
        var buffer = ""
        for char in self {
            if delimiters.contains(char) {
                output.append(buffer)
                buffer = String(char)
            } else {
                buffer += String(char)
            }
        }
        output.append(buffer)
        return output
    }
}

extension Double {
    /// Rounds the double to the specified number of decimal places.
    func roundToPlaces(_ places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension UInt {
    /// Formats the UInt in the format `1.1K`.
    func formatPoints() -> String {
        var digits = 0
        var n = Double(self)
        repeat {
            n /= 10
            digits += 1
        } while n >= 1
        let rounded = Double(Int(Double(self) / Double(pow(10, Double(digits - (digits % 3 == 0 ? 3 : digits % 3)))) * 10)) / 10
        if digits > 9 {
            return "\(rounded)B"
        } else if digits > 6 {
            return "\(rounded)M"
        } else if digits > 3 {
            return "\(rounded)K"
        } else {
            return "\(self)"
        }
    }
}

extension AnyView {
    static func + (left: AnyView, right: AnyView) -> AnyView {
        AnyView(
            HStack(spacing: 0) {
                left
                    .fixedSize(horizontal: true, vertical: false)
                right
                    .fixedSize(horizontal: true, vertical: false)
            }
        )
    }
}

extension UIColor {
    public convenience init?(hexString: String) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 1
        var hex = hexString
        
        if hex.hasPrefix("#") {
            hex.removeFirst()
        }
        
        let scanner = Scanner(string: hex)
        var hexNumber: UInt64 = 0
        
        if scanner.scanHexInt64(&hexNumber) {
            if hex.count == 6 {
                r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                b = CGFloat((hexNumber & 0x0000ff) >> 0) / 255
            }
            if hex.count == 8 {
                r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                a = CGFloat(hexNumber & 0x000000ff) / 255
            }
        }
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
}

extension UIColor {
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        return (red, green, blue, alpha)
    }
}

extension UIColor {
    convenience init(readableBackgroundFor color: UIColor, backgroundAlpha: CGFloat = 1) {
        let rgba = color.rgba
        self.init(white: (rgba.red + rgba.green + rgba.blue) / 3 > 0.5 ? 1 - ((rgba.red + rgba.green + rgba.blue) / 3 - 0.5) * 2 : 1, alpha: backgroundAlpha)
    }
}
