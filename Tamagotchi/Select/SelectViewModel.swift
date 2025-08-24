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
        
//        tamagotchi
//            .bind(to: collectionView.rx.items(cellIdentifier: TamagotchiCollectionViewCell.identifier, cellType: TamagotchiCollectionViewCell.self)) { row, tamagotchi, cell in
//                cell.tamagotchiView.configure(with: tamagotchi)
//            }
//            .disposed(by: disposeBag)
//        
//        collectionView.rx.modelSelected(Tamagotchi.self)
//            .bind(with: self) { owner, tamagotchi in
//                
//                guard tamagotchi.kind != .none else { return }
//                
//                let vc = SelectDetailViewController()
//                
//                vc.modalPresentationStyle = .overCurrentContext
//                vc.modalTransitionStyle = .crossDissolve
//                vc.tamagotchi = tamagotchi
//                
//                owner.present(vc, animated: true)
//            }
//            .disposed(by: disposeBag)
    }
}
