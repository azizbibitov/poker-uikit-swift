//
//  View.swift
//  PokerUIKit
//
//  Created by Aziz Bibitov on 04/01/2026.
//

import SwiftUI
import UIKit

extension View {
    /// Wrap SwiftUI view in UIHostingController, with optional presentation style
    func viewController(presentationStyle: UIModalPresentationStyle = .automatic) -> UIViewController {
        let vc = UIHostingController(rootView: self)
        vc.modalPresentationStyle = presentationStyle
        return vc
    }
}
