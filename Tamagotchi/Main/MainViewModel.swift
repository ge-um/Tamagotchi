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
