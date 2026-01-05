//
//  Defaults.swift
//  PokerUIKit
//
//  Created by Aziz Bibitov on 03/01/2026.
//

import Foundation

enum DefaultsKey: String {
    case userOnboarded
    case score
}

class Defaults: NSObject {
    
    static var userOnboarded: Bool {
        get { UserDefaults.standard.bool(forKey: DefaultsKey.userOnboarded.rawValue) }
        set { UserDefaults.standard.setValue(newValue, forKey: DefaultsKey.userOnboarded.rawValue)}
    }
    
    static var score: Int {
        get { UserDefaults.standard.integer(forKey: DefaultsKey.score.rawValue) }
        set { UserDefaults.standard.setValue(newValue, forKey: DefaultsKey.score.rawValue)}
    }
    
}
