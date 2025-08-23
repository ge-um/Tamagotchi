//
//  Tamagotchi.swift
//  Tamagotchi
//
//  Created by 금가경 on 8/23/25.
//

import Foundation

struct Tamagotchi {
    let kind: Kind
    var level: Int
    
    var name: String {
        return kind.characteristic + " 다마고치"
    }
    
    var imageName: String {
        return "\(kind.rawValue)-\(level)"
    }
}

enum Kind: Int {
    case one = 1
    case two
    case three
    
    var characteristic: String {
        switch self {
        case .one: "따끔따끔"
        case .two: "방실방실"
        case .three: "반짝반짝"
        }
    }
}
