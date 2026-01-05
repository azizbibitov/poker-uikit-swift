//
//  QuizFactory.swift
//  PokerUIKit
//
//  Created by Aziz Bibitov on 04/01/2026.
//

import Foundation

struct QuizFactory {

    static func makeQuestion(
        answersCount: Int = 4
    ) -> QuizModel {

        // 1. Pick correct answer
        let correct = PokerCombination.allCases.randomElement()!

        // 2. Pick wrong answers
        let wrongAnswers = PokerCombination.allCases
            .filter { $0 != correct }
            .shuffled()
            .prefix(answersCount - 1)

        // 3. Combine + shuffle
        let answers = ([correct] + wrongAnswers).shuffled()

        return QuizModel(
            question: correct,
            answers: answers,
            correctAnswer: correct
        )
    }
    
    static func makeQuizUnique() -> [QuizModel] {
        PokerCombination.allCases.map { combination in
            let wrongAnswers = PokerCombination.allCases
                .filter { $0 != combination }
                .shuffled()
                .prefix(3)

            let answers = ([combination] + wrongAnswers).shuffled()

            return QuizModel(
                question: combination,
                answers: answers,
                correctAnswer: combination
            )
        }.shuffled()
    }

}
