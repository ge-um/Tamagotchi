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
        return kind.characteristic
    }
    
    var imageName: String {
        return kind == .none ? "noImage" : "\(kind.rawValue)-\(level)"
    }
}

enum Kind: Int, CaseIterable {
    case one = 1
    case two
    case three
    case none
    
    var characteristic: String {
        switch self {
        case .one: "따끔따끔 다마고치"
        case .two: "방실방실 다마고치"
        case .three: "반짝반짝 다마고치"
        case .none: "준비중이에요"
        }
    }
}
