//
//  Color.swift
//  PokerUIKit
//
//  Created by Aziz Bibitov on 04/01/2026.
//

import SwiftUI

extension Color {
    static let main = Color(hex: "#8A3A77")
    static let pokerBlack = Color(hex: "#2E212B")
    static let lightGr = Color(hex: "#f4f7fa")
    static let red = Color(hex: "#d31111")
    static let color12 = Color(hex: "#d3dfe9")
    static let green = Color(hex: "#1b9b28")
    static let cdGray = Color(hex: "#cdcdcd")
    static let skyBlue = Color(hex: "#4db4fe")
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hex)

        if hex.hasPrefix("#") {
            scanner.currentIndex = scanner.string.index(after: scanner.string.startIndex)
        }

        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)

        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8) & 0xFF) / 255
        let b = Double(rgb & 0xFF) / 255

        self.init(red: r, green: g, blue: b)
    }
}
