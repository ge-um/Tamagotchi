//
//  UserDefaultsKey.swift
//  Tamagotchi
//
//  Created by 금가경 on 8/23/25.
//

import Foundation

enum UserDefaultsKey: String {
    case name
}

extension UserDefaults {
    func set(_ value: Any?, forKey key: UserDefaultsKey) {
        set(value, forKey: key.rawValue)
    }
}
