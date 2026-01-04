//
//  UIView.swift
//  PokerUIKit
//
//  Created by Aziz Bibitov on 03/01/2026.
//

import UIKit.UIView

extension UIView {

    static func spacer(width: CGFloat) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: width)
        ])
        return view
    }

    static func spacer(height: CGFloat) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: height)
        ])
        return view
    }
}

