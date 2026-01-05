//
//  GlassButton.swift
//  PokerUIKit
//
//  Created by Aziz Bibitov on 04/01/2026.
//

import Foundation
import SwiftUI

struct GlassButton: View {
    
    @State private var isPressed = false
    
    let title: String
    let titleColor: Color
    let backgroundColor: Color
    let font: Font
    let cornerRadius: CGFloat
    let borderWidth: CGFloat
    let borderColor: Color
    let makeGlass: Bool
    let width: CGFloat?
    let height: CGFloat?
    let action: () -> Void

    init(
        title: String,
        titleColor: Color = .white,
        backgroundColor: Color = .blue,
        font: Font = .system(size: 18, weight: .semibold),
        cornerRadius: CGFloat = 12,
        borderWidth: CGFloat = 0,
        borderColor: Color = .clear,
        makeGlass: Bool = true,
        width: CGFloat? = nil,
        height: CGFloat? = 50,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.titleColor = titleColor
        self.backgroundColor = backgroundColor
        self.font = font
        self.cornerRadius = cornerRadius
        self.borderWidth = borderWidth
        self.borderColor = borderColor
        self.makeGlass = makeGlass
        self.width = width
        self.height = height
        self.action = action
    }

    var body: some View {
        let buttonContent = Text(title)
            .font(font)
            .foregroundColor(titleColor)
            .lineLimit(1)
        
        if #available(iOS 26.0, *), makeGlass {
            Button(action: action) {
                let height = height! - 14
                let width = width! - 23
                buttonContent
                    .frame(width: width, height: height)
            }
            .buttonStyle(.glassProminent)
            .buttonBorderShape(.roundedRectangle(radius: cornerRadius))
            .tint(backgroundColor)
            
        } else {
            Button(action: action) {
                buttonContent
                    .frame(width: width, height: height)
                    .background(backgroundColor)
                    .cornerRadius(cornerRadius)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(borderColor, lineWidth: borderWidth)
                    )
                    .shadow(
                        color: Color.black.opacity(isPressed ? 0.15 : 0.25),
                        radius: isPressed ? 4 : 8,
                        x: 0,
                        y: isPressed ? 2 : 6
                    )
                    .scaleEffect(isPressed ? 0.96 : 1)
                    .opacity(isPressed ? 0.85 : 1)
                    .animation(.easeOut(duration: 0.15), value: isPressed)
                
            }
            .buttonStyle(.plain)
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        isPressed = true
                    }
                    .onEnded { _ in
                        isPressed = false
                    }
            )
        }
    }
}

