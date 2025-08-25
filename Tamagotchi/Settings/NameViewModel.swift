//
//  NameViewModel.swift
//  Tamagotchi
//
//  Created by 금가경 on 8/25/25.
//

import Foundation
import RxCocoa
import RxSwift

final class NameViewModel: InputOutput {
    struct Input {
        let rightBarButtonTapped: Observable<String>
    }
    
    struct Output {
        let pop: Observable<Void>
    }
    
    func transform(input: Input) -> Output {
        let pop = input.rightBarButtonTapped
            .filter { (2...6) ~= $0.count }
            .do { name in
                UserDefaults.standard.set(name, forKey: .name)
            }
            .compactMap() { _ in ()}

        return Output(pop: pop)
    }
}
