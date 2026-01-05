//
//  UIButton.swift
//  PokerUIKit
//
//  Created by Aziz Bibitov on 30/12/2025.
//

import UIKit.UIButton

extension UIButton {

    func makeGlassButton(
        title: String,
        titleColor: UIColor,
        backgroundColor: UIColor,
        font: UIFont,
        cornerRadius: CGFloat,
        borderWidth: CGFloat = 0,
        borderColor: UIColor = .clear,
        makeGlass: Bool = true
    ) {

        if #available(iOS 26, *), makeGlass {

            var config = UIButton.Configuration.prominentClearGlass()

            // Title
            config.attributedTitle = AttributedString(
                title,
                attributes: AttributeContainer([
                    .font: font,
                    .foregroundColor: titleColor
                ])
            )

            // Colors
            config.baseBackgroundColor = backgroundColor
            config.baseForegroundColor = titleColor

            // Corner radius
            config.cornerStyle = .dynamic
            config.background.cornerRadius = cornerRadius

            // ✅ Border (THIS is the correct way)
            if borderWidth > 0 {
                config.background.strokeWidth = borderWidth
                config.background.strokeColor = borderColor
            }

            self.configuration = config

            // Keep colors stable during state changes
            self.configurationUpdateHandler = { button in
                button.configuration?.baseForegroundColor = titleColor
                button.configuration?.background.strokeColor = borderColor
            }

            // Text behavior
            self.titleLabel?.adjustsFontSizeToFitWidth = true
            self.titleLabel?.minimumScaleFactor = 0.7
            self.titleLabel?.lineBreakMode = .byTruncatingTail

        } else {
            // ⬅️ Classic UIButton fallback
            self.layer.cornerRadius = cornerRadius
            self.layer.borderWidth = borderWidth
            self.layer.borderColor = borderColor.cgColor
            self.backgroundColor = backgroundColor

            self.setTitle(title, for: .normal)
            self.setTitleColor(titleColor, for: .normal)
            self.titleLabel?.font = font
        }
    }
}
