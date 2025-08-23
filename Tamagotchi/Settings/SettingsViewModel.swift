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
        let itemSelected: ControlEvent<IndexPath>
    }
    
    struct Output {
        let items: Driver<[Setting]>
        let name: BehaviorRelay<String>
        let nextViewController: Driver<Int>
    }
    
    private let disposeBag = DisposeBag()
    
    init() {}
    
    func transform(input: Input) -> Output {
        let items = BehaviorRelay(value: Setting.list)
            .asDriver()
        
        let name = BehaviorRelay(value: "고래밥")
        
        let nextViewController = input.itemSelected
            .asDriver()
            .map { $0.row }

        return Output(items: items, name: name, nextViewController: nextViewController)
    }
}
