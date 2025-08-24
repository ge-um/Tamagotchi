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
    }
    
    private let tamagotchi: Tamagotchi
    
    init(tamagotchi: Tamagotchi) {
        self.tamagotchi = tamagotchi
    }
    
    func transform(input: Input) -> Output {
        let tamagotchi = Observable.just(tamagotchi)
        
        let title = input.viewWillAppear
            .map { "\(UserDefaults.standard.string(forKey: .name) ?? "대장")님의 다마고치"}
        
        return Output(tamagotchi: tamagotchi, title: title)
    }
    
//    name
//        .compactMap { $0 }
//        .map { "\($0)님의 다마고치" }
//        .bind(to: navigationItem.rx.title)
//        .disposed(by: disposeBag)
//    
//    navigationItem.rightBarButtonItem?.rx.tap
//        .asDriver()
//        .drive(with: self) { owner, _ in
//            let vc = SettingsViewController()
//            owner.navigationController?.pushViewController(vc, animated: true)
//        }
//        .disposed(by: disposeBag)
//    
//    message
//        .bind(to: messageLabel.rx.text)
//        .disposed(by: disposeBag)
//    
//    // TODO: - self 떼내기
//    // TODO: - refactoring
//    Observable.combineLatest(meal, water)
//        .compactMap { meal, water -> (Int, Int) in
//            (Int(meal ?? "0")!, Int(water ?? "0")!)
//        }
//        .map { (meal, water) -> String in
//            let calculated = meal/5 + water/2
//            let level = calculated < 1 ? 1 : min(calculated, 10)
//            
//            self.tamagotchiView.tamagotchi.level = level == 10 ? 9 : level
//            self.tamagotchiView.updateImage(with: self.tamagotchi)
//
//            return "LV\(level) · 밥알 \(meal)개 · 물방울 \(water)개"
//        }
//        .bind(to: statusLabel.rx.text)
//        .disposed(by: disposeBag)
//    
//    meal
//        .subscribe(onNext: { UserDefaults.standard.set($0, forKey: .meal) })
//        .disposed(by: disposeBag)
//
//    water
//        .subscribe(onNext: { UserDefaults.standard.set($0, forKey: .water) })
//        .disposed(by: disposeBag)
//
//    name
//        .subscribe(onNext: { UserDefaults.standard.set($0, forKey: .name) })
//        .disposed(by: disposeBag)
//    
//    mealView.feedButton.rx.tap
//        .withLatestFrom(mealView.textField.rx.text.orEmpty)
//        .filter { $0.allSatisfy { $0.isNumber } }
//        .compactMap { Int($0) ?? 1 }
//        .filter { $0 < 100 }
//        .subscribe(with: self) { owner, add in
//            let count = Int(owner.meal.value ?? "0")! + add
//            owner.meal.accept("\(count)")
//            owner.messageLabel.text = owner.talks.randomElement()!
//        }
//        .disposed(by: disposeBag)
//
//    waterView.feedButton.rx.tap
//        .withLatestFrom(waterView.textField.rx.text.orEmpty)
//        .filter { $0.allSatisfy { $0.isNumber } }
//        .compactMap { Int($0) ?? 1 }
//        .filter { $0 < 50 }
//        .subscribe(with: self) { owner, add in
//            let count = Int(owner.water.value ?? "0")! + add
//            owner.water.accept("\(count)")
//            owner.messageLabel.text = owner.talks.randomElement()!
//        }
//        .disposed(by: disposeBag)
}
