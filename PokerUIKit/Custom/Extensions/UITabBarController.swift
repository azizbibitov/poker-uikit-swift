//
//  UITabbarController.swift
//  PokerUIKit
//
//  Created by Aziz Bibitov on 04/01/2026.
//

import UIKit.UITabBarController

extension UITabBarController {
    func switchToTab(index: Int, animated: Bool = true) {
        guard
            let viewControllers = viewControllers,
            index >= 0,
            index < viewControllers.count
        else { return }

        selectedIndex = index
    }
}
