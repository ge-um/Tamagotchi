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
    
    var message: String {
        return kind.info
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
    
    var info: String {
        return """
            저는 \(characteristic)입니당 키는 100km
            몸무게는 150톤이에용
            성격은 화끈하고 날라다닙니당~!
            열심히 잘 먹고 잘 클 자신은
            있답니당 방실방실! 
            """
    }
}
