//
//  UserDefaultsKey.swift
//  Tamagotchi
//
//  Created by 금가경 on 8/23/25.
//

import Foundation

enum UserDefaultsKey: String {
    case name
    case level
    case meal
    case water
}

extension UserDefaults {
    func set(_ value: Any?, forKey key: UserDefaultsKey) {
        set(value, forKey: key.rawValue)
    }
    
    func string(forKey key: UserDefaultsKey) -> String? {
        string(forKey: key.rawValue)
    }
}
