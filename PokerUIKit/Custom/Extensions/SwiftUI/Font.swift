//
//  Font.swift
//  PokerUIKit
//
//  Created by Aziz Bibitov on 04/01/2026.
//

import SwiftUI

extension Font {

    static func regular(_ size: CGFloat) -> Font {
        .custom("ProductSans-Regular", size: size)
    }

    static func bold(_ size: CGFloat) -> Font {
        .custom("ProductSans-Bold", size: size)
    }

    static func italic(_ size: CGFloat) -> Font {
        .custom("ProductSans-Italic", size: size)
    }

    static func boldItalic(_ size: CGFloat) -> Font {
        .custom("ProductSans-BoldItalic", size: size)
    }
}
