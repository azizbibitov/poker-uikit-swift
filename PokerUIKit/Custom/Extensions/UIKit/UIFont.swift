//
//  Fonts.swift
//  PokerUIKit
//
//  Created by Aziz Bibitov on 28/12/2025.
//

import UIKit.UIFont

extension UIFont {
    
    class func regular(size: CGFloat) -> UIFont {
        return UIFont(name: "ProductSans-Regular", size: size)!
    }
    
    class func bold(size: CGFloat) -> UIFont {
        return UIFont(name: "ProductSans-Bold", size: size)!
    }

    class func italic(size: CGFloat) -> UIFont {
        return UIFont(name: "ProductSans-Italic", size: size)!
    }

    class func boldItalic(size: CGFloat) -> UIFont {
        return UIFont(name: "ProductSans-BoldItalic", size: size)!
    }
}
