//
//  IsIdentifiable.swift
//  Tamagotchi
//
//  Created by 금가경 on 8/22/25.
//

import Foundation

protocol IsIdentifiable {
    static var identifier: String { get }
}

extension IsIdentifiable {
    static var identifier: String {
        return String(describing: Self.self)
    }
}
