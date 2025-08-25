//
//  Lotto.swift
//  Tamagotchi
//
//  Created by 금가경 on 8/25/25.
//

import Foundation

struct Lotto: Decodable {
    let drwtNo1: Int
    let drwtNo2: Int
    let drwtNo3: Int
    let drwtNo4: Int
    let drwtNo5: Int
    let drwtNo6: Int
    let bnusNo: Int
    
    var numbers: [Int] {
        return [drwtNo1, drwtNo2, drwtNo3, drwtNo4, drwtNo5, drwtNo6, bnusNo]
    }
}
