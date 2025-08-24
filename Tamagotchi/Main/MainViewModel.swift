//
//  MainViewModel.swift
//  Tamagotchi
//
//  Created by 금가경 on 8/25/25.
//

import Foundation
import RxCocoa
import RxSwift

final class MainViewModel: InputOutput {
    struct Input {
        let viewWillAppear: Observable<Void>
    }
    
    struct Output {
        let tamagotchi: Observable<Tamagotchi>
        let title: Observable<String>
        let message: Observable<String>
    }
    
    private let tamagotchi: Tamagotchi
    private let userName = UserDefaults.standard.string(forKey: .name) ?? "대장"
    
    init(tamagotchi: Tamagotchi) {
        self.tamagotchi = tamagotchi
    }
    
    func transform(input: Input) -> Output {
        let tamagotchi = Observable.just(tamagotchi)
        
        let title = input.viewWillAppear
            .withUnretained(self)
            .map { "\($0.0.userName)님의 다마고치"}
        
        let message = input.viewWillAppear
            .withUnretained(self)
            .map { $0.0.randomMessage() }
            
        return Output(tamagotchi: tamagotchi, title: title, message: message)
    }
    
    private func randomMessage() -> String {
        return [
            "복습 아직 안하셨다구요? 지금 잠이 오세여? \(userName)님??",
            "테이블뷰컨트롤러와 뷰컨트롤러는 어떤 차이가 있을까요? \(userName)님?",
            "\(userName)님 오늘 깃허브 푸시 하셨어영?",
            "\(userName)님!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        ].randomElement()!
    }
}
