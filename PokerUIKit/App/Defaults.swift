//
//  Defaults.swift
//  PokerUIKit
//
//  Created by Aziz Bibitov on 03/01/2026.
//

import Foundation

enum DefaultsKey: String {
    case userOnboarded
}

class Defaults: NSObject {
    
    static var userOnboarded: Bool {
        get { UserDefaults.standard.bool(forKey: DefaultsKey.userOnboarded.rawValue) }
        set { UserDefaults.standard.setValue(newValue, forKey: DefaultsKey.userOnboarded.rawValue)}
    }
    
}
