//
//  SelectViewModel.swift
//  Tamagotchi
//
//  Created by 금가경 on 8/24/25.
//


import Foundation
import RxCocoa
import RxSwift

final class SelectViewModel: InputOutput {
    struct Input {
        let itemSelected: Observable<Tamagotchi>
    }
    
    struct Output {
        let tamagotchi: Observable<[Tamagotchi]>
        let selectedTamagotchi: Observable<Tamagotchi>
    }
    
    func transform(input: Input) -> Output {
        let tamagotchi = Observable.just((Kind.allCases + Array(repeating: Kind.none, count: 20))
            .map { Tamagotchi(kind: $0, level: 6) })
        
        return Output(tamagotchi: tamagotchi,
                      selectedTamagotchi: input.itemSelected
            .filter { $0.kind != .none } )
    }
}
