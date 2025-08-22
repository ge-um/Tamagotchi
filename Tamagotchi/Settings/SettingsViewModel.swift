//
//  SettingsViewModel.swift
//  Tamagotchi
//
//  Created by 금가경 on 8/22/25.
//

import Foundation
import RxCocoa
import RxSwift

final class SettingsViewModel: InputOutput {
    struct Input {
        
    }
    
    struct Output {
        let items: Driver<[Setting]>
    }
    
    init() {}
    
    func transform(input: Input) -> Output {
        let items = BehaviorRelay(value: Setting.list)
            .asDriver()

        return Output(items: items)
    }
}
