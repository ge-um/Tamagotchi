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
        let rightBarButtonTapped: Observable<Void>
        let addMeal: Observable<String>
        let addWater: Observable<String>
    }
    
    struct Output {
        let tamagotchi: Observable<Tamagotchi>
        let title: Observable<String>
        let message: Observable<String>
        let status: Observable<String>
        let navigateToSettings: Observable<Void>
    }
    
    private let disposeBag = DisposeBag()
    
    private let tamagotchi: Tamagotchi
    
    let meal = BehaviorSubject(value: UserDefaults.standard.integer(forKey: .meal) ?? 0)
    let water = BehaviorSubject(value: UserDefaults.standard.integer(forKey: .water) ?? 0)
    let level = BehaviorSubject(value: 1)
    
    init(tamagotchi: Tamagotchi) {
        self.tamagotchi = tamagotchi
    }
    
    func transform(input: Input) -> Output {        
        let name = input.viewWillAppear
            .map { UserDefaults.standard.string(forKey: .name) ?? "대장" }
            .share()
        
        name
            .subscribe(onNext: { UserDefaults.standard.set($0, forKey: .name) })
            .disposed(by: disposeBag)
        
        let title = name
            .map { "\($0)님의 다마고치" }
            
        let message = name
            .withUnretained(self)
            .map { owner, name in
                owner.randomMessage(userName: name)
            }

        input.addMeal
            .filter { $0.allSatisfy { $0.isNumber } }
            .compactMap { Int($0) ?? 1 }
            .filter { $0 < 100 }
            .withLatestFrom(meal) { add, current in
                current + add
            }
            .bind(to: meal)
            .disposed(by: disposeBag)
        
        input.addWater
            .filter { $0.allSatisfy { $0.isNumber } }
            .compactMap { Int($0) ?? 1 }
            .filter { $0 < 50 }
            .withLatestFrom(water) { add, current in
                current + add
            }
            .bind(to: water)
            .disposed(by: disposeBag)
        
        let updatedLevel = Observable.combineLatest(meal, water)
            .map { meal, water in
                let calculated = meal/5 + water/2
                let level = max(1, min(calculated, 10))
                return level
            }
            .share()
        
        updatedLevel
            .bind(to: level)
            .disposed(by: disposeBag)
        
        let updatedTamagotchi = updatedLevel
            .map { [unowned self] newLevel -> Tamagotchi in
                var newTamagotchi = self.tamagotchi
                newTamagotchi.level = newLevel
                return newTamagotchi
            }
        
        let status = Observable.combineLatest(meal, water, level)
            .map { meal, water, level in
                "LV\(level) · 밥알 \(meal)개 · 물방울 \(water)개"
            }
        
        water
            .subscribe(onNext: { UserDefaults.standard.set($0, forKey: .water) })
            .disposed(by: disposeBag)
        
        meal
            .subscribe(onNext: { UserDefaults.standard.set($0, forKey: .meal) })
            .disposed(by: disposeBag)
        
        let navigateToSettings = input.rightBarButtonTapped
                    
        return Output(tamagotchi: updatedTamagotchi, title: title, message: message, status: status, navigateToSettings: navigateToSettings)
    }
    
    private func randomMessage(userName: String) -> String {
        return [
            "복습 아직 안하셨다구요? 지금 잠이 오세여? \(userName)님??",
            "테이블뷰컨트롤러와 뷰컨트롤러는 어떤 차이가 있을까요? \(userName)님?",
            "\(userName)님 오늘 깃허브 푸시 하셨어영?",
            "\(userName)님!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        ].randomElement()!
    }
}
