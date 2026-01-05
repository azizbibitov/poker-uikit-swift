//
//  Models.swift
//  PokerUIKit
//
//  Created by Aziz Bibitov on 03/01/2026.
//

import Foundation
import SwiftUI

struct OnboardingData {
    var image: String
    var text: String
}

var onboardings: [OnboardingData] = [
    OnboardingData(image: "onboard_1", text: "Study Combinations"),
    OnboardingData(image: "onboard_2", text: "Test your knowledge"),
    OnboardingData(image: "onboard_3", text: "View the clubs nearby"),
    OnboardingData(image: "onboard_4", text: "Track your debit/credit"),
]


struct CombinationModel {
    var title: String?
    var image: String?
    var description: String?
}

var combinations: [CombinationModel] = [
    CombinationModel(description: "Here you can study combinations in poker. To move forward - swipe to the right. To go back - swipe to the left"),
    CombinationModel(title: "Pair", image: "pair", description: "It is the youngest hand and is made up of two cards of the same value. Two Aces is the highest combination of Pairs in poker."),
    CombinationModel(title: "Two Pairs", image: "two_pairs", description: "It is built from two groups of paired cards at face value. At the same time, Two pairs have the greatest value, in which one of the pairs is made up of cards of a high rank - pictures."),
    CombinationModel(title: "Three of a kind", image: "three_kind", description: "Consists of three cards of equal value. If you come across the word Set, it means that the player made a Three on two pocket cards, if Trips, we are talking about all other cases."),
    CombinationModel(title: "Straight", image: "straight", description: "All five cards must go in order of their rank in the same way as in an unsorted deck. In the table of combinations in poker by seniority, this is the first and lowest of the five-card cards."),
    CombinationModel(title: "Flush", image: "flush", description: "All five cards of the player at the showdown turned out to be of the same suit. It should be borne in mind that they should not form an order at face value, otherwise a stronger combination is formed."),
    CombinationModel(title: "Full House", image: "full_house", description: "Three cards of equal value and two more pairs. It turns out that the poker player has a Pair and a Three in his hands at the same time."),
    CombinationModel(title: "Four of a kind", image: "four_kind", description: "It is made up of four identical cards, and the strength depends on their rank."),
    CombinationModel(title: "Straight-flush", image: "straight_flush", description: "It is, in fact, a symbiosis of Flush and Straight, since all the cards in it form an order and at the same time their suits are equal."),
    CombinationModel(title: "Royal Flush", image: "royal_flush", description: "It consists of 5 high cards of the same suit, ending with an ace, and always guarantees the participant a victory."),
    CombinationModel(description: "That was the last pierce of information, seems you are ready to test your knowledge!"),
]

enum PokerCombination: String, CaseIterable {
    case pair
    case twoPairs = "two_pairs"
    case threeKind = "three_kind"
    case straight
    case flush
    case fullHouse = "full_house"
    case fourKind = "four_kind"
    case straightFlush = "straight_flush"
    case royalFlush = "royal_flush"
    
    // Computed property to get a human-readable name
    var displayName: String {
        switch self {
        case .pair:
            return "Pair"
        case .twoPairs:
            return "Two Pairs"
        case .threeKind:
            return "Three of a Kind"
        case .straight:
            return "Straight"
        case .flush:
            return "Flush"
        case .fullHouse:
            return "Full House"
        case .fourKind:
            return "Four of a Kind"
        case .straightFlush:
            return "Straight-Flush"
        case .royalFlush:
            return "Royal Flush"
        }
    }
}


struct QuizModel {
    let question: PokerCombination
    let answers: [PokerCombination]
    let correctAnswer: PokerCombination
}

enum Toast {
    case error(title: String, desc: String)
    case warning(title: String, desc: String)
    case success(title: String, desc: String)
    
    var color: Color {
        switch self {
        case .error:
            return .errorOn
        case .warning:
            return .warningOn
        case .success:
            return .successOn
        }
    }
    
    var icon: String {
        switch self {
        case .error:
            return "circle-x"
        case .warning:
            return "warning"
        case .success:
            return "circle-check"
        }
    }
    
    var title: String {
        switch self {
        case .error(let title, _):
            return title
        case .warning(let title, _):
            return title
        case .success(let title, _):
            return title
        }
    }
    
    var desc: String {
        switch self {
        case .error(_, let desc):
            return desc
        case .warning(_, let desc):
            return desc
        case .success(_, let desc):
            return desc
        }
    }
}
