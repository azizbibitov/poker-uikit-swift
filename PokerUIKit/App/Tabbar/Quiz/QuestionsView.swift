//
//  QuestionsView.swift
//  PokerUIKit
//
//  Created by Aziz Bibitov on 04/01/2026.
//

import SwiftUI
import Combine

struct GlassButton: View {
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
            .frame(width: width, height: height)
            .lineLimit(1)
        
        if #available(iOS 26.0, *), makeGlass {
            Button(action: action) {
                buttonContent
            }
            .buttonStyle(.glassProminent)
            .tint(backgroundColor)
            
          
        } else {
            Button(action: action) {
                buttonContent
            }
        }
    }
}

struct QuestionsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    GlassButton(
                        title: "Start",
                        titleColor: .white,
                        backgroundColor: Color.main,
                        font: .regular(18),
                        cornerRadius: 16,
                        borderWidth: 0,
                        borderColor: .clear,
                        makeGlass: true,
                        width: 310,
                        height: 50
                    ) {
                        print("Tapped!")
                    }
                    .padding()

                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                questionToolbarItems
            }
        }
    }
    
    @ToolbarContentBuilder
    private var questionToolbarItems: some ToolbarContent {
        // Leading item
        if #available(iOS 26.0, *) {
            ToolbarItem(placement: .navigationBarLeading) {
                Text("Question 1/10")
                    .font(.regular(30))
                    .foregroundColor(.pokerBlack)
                    .fixedSize(horizontal: true, vertical: false)
            }
            .sharedBackgroundVisibility(.hidden)
        } else {
            ToolbarItem(placement: .navigationBarLeading) {
                Text("Question 1/10")
                    .font(.regular(30))
                    .foregroundColor(.pokerBlack)
                    .fixedSize(horizontal: true, vertical: false)
            }
        }
        
        // Trailing item
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                dismiss()
            } label: {
                Image("close")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(Color.pokerBlack)
                    .frame(width: 32, height: 32)
            }
        }
    }
}


class QuestionsVM: ObservableObject {
    var quizQuestions: [QuizModel] = []
    @Published var currentQuestionIndex = 1
    @Published var currentQuestion: QuizModel?
    var score: Int = 0
    
    init() {
        quizQuestions = QuizFactory.makeQuizUnique()
        currentQuestion = quizQuestions[currentQuestionIndex]
    }
    
    func nextQuestion() {
        checkAnswer()
        currentQuestionIndex += 1
        currentQuestion = quizQuestions[currentQuestionIndex-1]
    }
    
    func checkAnswer() {
        
    }
    
}

#Preview {
    QuestionsView()
}
