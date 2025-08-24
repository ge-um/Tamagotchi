//
//  SelectDetailViewModel.swift
//  Tamagotchi
//
//  Created by 금가경 on 8/24/25.
//

import Foundation
import RxCocoa
import RxSwift

final class SelectDetailViewModel: InputOutput {
    struct Input {
        let startTap: Observable<Void>
        let cancelTap: Observable<Void>
    }
    
    struct Output {
        let tamagotchi: Observable<Tamagotchi>
        let changeRoot: Observable<Tamagotchi>
        let dismiss: Observable<Void>
    }
    
    let tamagotchi: Tamagotchi
    
    init(tamagotchi: Tamagotchi) {
        self.tamagotchi = tamagotchi
    }
    
    func transform(input: Input) -> Output {
        let tamagotchi = Observable.just(tamagotchi)
        
        let changeRoot = input.startTap
            .withUnretained(self)
            .map { $0.0.tamagotchi }
            
        let dismiss = input.cancelTap

        return Output(tamagotchi: tamagotchi, changeRoot: changeRoot, dismiss: dismiss)
    }
}
