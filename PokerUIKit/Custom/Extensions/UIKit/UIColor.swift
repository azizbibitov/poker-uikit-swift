//
//  UIColor.swift
//  PokerUIKit
//
//  Created by Aziz Bibitov on 28/12/2025.
//

import UIKit.UIColor

extension UIColor {
    static let main = UIColor(hex: "#8A3A77") ?? .white
    static let pokerBlack = UIColor(hex: "#2E212B") ?? .white
    static let lightGr = UIColor(hex: "#f4f7fa") ?? .white
    static let red = UIColor(hex: "#d31111") ?? .white
    static let color12 = UIColor(hex: "#d3dfe9") ?? .white
    static let green = UIColor(hex: "#1b9b28") ?? .white
    static let cdGray = UIColor(hex: "#cdcdcd") ?? .white
    static let skyBlue = UIColor(hex: "#4db4fe") ?? .white
}

extension UIColor {
    convenience init?(hex: String?) {
        if hex == "" || hex?.starts(with: "#") == false || (hex?.count == 7) == false {
            self.init(red: 0, green: 0, blue: 0, alpha: 1)
            return
        }
        
        let input: String! = (hex ?? "").replacingOccurrences(of: "#", with: "").uppercased()
        var red: CGFloat = 0
        var blue: CGFloat = 0
        var green: CGFloat = 0
            
        red = Self.colorComponent(from: input, start: 0, length: 2)
        green = Self.colorComponent(from: input, start: 2, length: 2)
        blue = Self.colorComponent(from: input, start: 4, length: 2)

        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
    
    static func colorComponent(from string: String!, start: Int, length: Int) -> CGFloat {
        let substring = (string as NSString)
            .substring(with: NSRange(location: start, length: length))
        let fullHex = length == 2 ? substring : "\(substring)\(substring)"
        var hexComponent: UInt64 = 0
        Scanner(string: fullHex)
            .scanHexInt64(&hexComponent)
        return CGFloat(Double(hexComponent) / 255.0)
    }
}
