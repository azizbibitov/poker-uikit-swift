//
//  QuestionsView.swift
//  PokerUIKit
//
//  Created by Aziz Bibitov on 04/01/2026.
//

import SwiftUI
import Combine

struct RadioButtonGroup: View {
    @EnvironmentObject private var questionsVM: QuestionsVM
 
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            ForEach(questionsVM.currentQuestion?.answers ?? [], id: \.self) { option in
                RadioButtonRow(
                    label: option.displayName,
                    isSelected: questionsVM.selectedOption == option
                ) {
                    questionsVM.selectedOption = option
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
          
        }
        .frame(width: 258)
    }
}

struct RadioButtonRow: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                ZStack {
                    Circle()
                        .stroke(isSelected ? Color.main : Color.pokerBlack, lineWidth: 2)
                        .frame(width: 20, height: 20)
                    if isSelected {
                        Circle()
                            .fill(Color.main)
                            .frame(width: 10, height: 10)
                    }
                }
                Text(label)
                    .font(.regular(20))
                    .foregroundColor(Color(hex: "#1F1F1F"))
                
              
            }
        }
        .buttonStyle(.plain)
    }
}

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

struct QuestionCardView: View {
    
    @EnvironmentObject private var questionsVM: QuestionsVM
    
    var body: some View {
        ZStack {
            VStack(spacing: 40){
                Text("What is the combination of that cards?")
                    .frame(width: 258)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.pokerBlack.opacity(0.7))
                
                Image(questionsVM.currentQuestion?.question.rawValue ?? "")
                
                RadioButtonGroup()
            }
        }
        .frame(width: 310, height: 520)
        .background(Color.color12)
        .clipShape(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
        )
        .padding(.top)
    }
}

struct QuestionsView: View {
    @StateObject private var viewModel = QuestionsVM()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                ScrollView{
                    
                    VStack(spacing: 62){
                        
                        QuestionCardView()
                        
                        GlassButton(
                            title: viewModel.btnName,
                            titleColor: .white,
                            backgroundColor: Color.main,
                            font: .regular(18),
                            cornerRadius: 16,
                            borderWidth: 0,
                            borderColor: .clear,
                            makeGlass: false,
                            width: 310,
                            height: 50
                        ) {
                            
                            
                            if viewModel.quizQuestions.count <= viewModel.currentQuestionIndex + 1 {
                                viewModel.saveScore()
                                dismiss()
                                return
                            }
                            viewModel.nextQuestion()
                        }
                        .padding()
                        
                    }
                    
                }
                .scrollIndicators(.hidden)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    questionToolbarItems
                }
                
                if let toast = viewModel.toast {
                    ToastView(data: toast)
                        .padding(16)
                        .padding(.bottom, 50)
                        .animation(.bouncy(duration: 0.2))
                        .transition(.move(edge: .bottom))
                }
                
            }
            
            
        }
        .environmentObject(viewModel)
    }
    
    @ToolbarContentBuilder
    private var questionToolbarItems: some ToolbarContent {
        // Leading item
        if #available(iOS 26.0, *) {
            ToolbarItem(placement: .navigationBarLeading) {
                Text("Question \(viewModel.currentQuestionIndex + 1)/\(viewModel.quizQuestions.count)")
                    .font(.regular(30))
                    .foregroundColor(.pokerBlack)
                    .fixedSize(horizontal: true, vertical: false)
            }
            .sharedBackgroundVisibility(.hidden)
        } else {
            ToolbarItem(placement: .navigationBarLeading) {
                Text("Question \(viewModel.currentQuestionIndex + 1)/\(viewModel.quizQuestions.count)")
                    .font(.regular(30))
                    .foregroundColor(.pokerBlack)
                    .fixedSize(horizontal: true, vertical: false)
            }
        }
        
        // Trailing item
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                viewModel.saveScore()
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
    @Published var currentQuestionIndex = 0
    @Published var currentQuestion: QuizModel?
    @Published var selectedOption: PokerCombination?
    @Published var btnName: String = "Next"
    @AppStorage("score") var score: Int = 0
    var currentScore: Int = 0
    
    @Published var toast: Toast? {
        didSet { removeToast() }
    }
    
    func removeToast() {
        if toast == nil { return }
        DispatchQueue.main.asyncAfter(deadline: .now()+5){
            self.toast = nil
        }
    }
    
    init() {
        quizQuestions = QuizFactory.makeQuizUnique()
        currentQuestion = quizQuestions[currentQuestionIndex]
    }
    
    func nextQuestion() {
        
        if selectedOption == nil {
            toast = .warning(title: "Warning", desc: "Select answer!")
            return
        }
        
        checkAnswer()
        currentQuestionIndex += 1
        currentQuestion = quizQuestions[currentQuestionIndex]
        selectedOption = nil
        if quizQuestions.count == currentQuestionIndex + 1 {
            btnName = "Finish"
        }
    }
    
    func saveScore(){
        if currentScore > score {
            score = currentScore
        }
    }
    
    func checkAnswer() {
        if currentQuestion?.correctAnswer == selectedOption {
            currentScore += 1
        }
    }
    
}

#Preview {
    QuestionsView()
}
