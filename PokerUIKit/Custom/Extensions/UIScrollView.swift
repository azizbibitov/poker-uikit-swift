//
//  UIScrollview.swift
//  PokerUIKit
//
//  Created by Aziz Bibitov on 03/01/2026.
//

import UIKit.UIScrollView

extension UIScrollView {
    var currentPage: Int {
        Int((self.contentOffset.x + frame.width / 2) / frame.width)
    }
}
