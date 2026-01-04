//
//  UIViewController.swift
//  PokerUIKit
//
//  Created by Aziz Bibitov on 29/12/2025.
//

import SwiftUI
import UIKit

// Make any UIViewController easily usable in SwiftUI
extension UIViewController {
    func swiftUIView() -> some View {
        UIKitViewControllerWrapper(viewController: self)
            .edgesIgnoringSafeArea(.all) // optional
    }
}

// Generic wrapper
struct UIKitViewControllerWrapper: UIViewControllerRepresentable {
    let viewController: UIViewController
    
    func makeUIViewController(context: Context) -> UIViewController {
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // You can update properties if needed
    }
}

