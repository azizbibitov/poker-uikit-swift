//
//  ToastView.swift
//  PokerUIKit
//
//  Created by Aziz Bibitov on 05/01/2026.
//

import SwiftUI

struct ToastView: View {
    @EnvironmentObject private var questionsVM: QuestionsVM
    var data: Toast
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(data.color).offset(x: 0, y: 4)
                .frame(height: 50)
            
            HStack(spacing: 12) {
                Image(data.icon)
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 20, height: 20, alignment: .center)
                    .foregroundColor(Color.bWhite)
                    .padding(8)
                    .background(data.color)
                    .cornerRadius(30)
                
                VStack(spacing: 4) {
                    Text(LocalizedStringKey(data.title))
                        .font(.regular(20))
                        .foregroundColor(.textSecondary)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text(LocalizedStringKey(data.desc))
                        .font(.regular(20))
                        .foregroundColor(.textPrimary)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Button {
                    withAnimation {
                        questionsVM.toast = nil
                    }
                } label: {
                    Image("cross-small")
                        .renderingMode(.template)
                        .foregroundColor(.primaryDisabled)
                        .frame(width: 24, height: 24, alignment: .center)
                }
            }.padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(Color.secondarySurface)
                .cornerRadius(12)
                .frame(maxWidth: .infinity)
        }.frame(maxWidth: UIScreen.main.bounds.width)
    }
}
