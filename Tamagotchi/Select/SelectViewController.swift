//
//  SelectViewController.swift
//  Tamagotchi
//
//  Created by 금가경 on 8/24/25.
//

import SnapKit
import RxCocoa
import RxSwift

import UIKit

final class SelectViewController: BaseViewController {
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 20
        layout.sectionInset = .init(top: 10, left: 20, bottom: 10, right: 20)
        
        let deviceWidth = view.frame.width
        let cellWidth = (deviceWidth - 20.0 * 2 - 20.0 * 2 ) / 3
        layout.itemSize = .init(width: cellWidth, height: cellWidth)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TamagotchiCollectionViewCell.self, forCellWithReuseIdentifier: TamagotchiCollectionViewCell.identifier)
        collectionView.backgroundColor = .clear
        
        return collectionView
    }()
    
    private let disposeBag = DisposeBag()
    
    private let tamagotchi = Observable.just((Kind.allCases + Array(repeating: Kind.none, count: 20))
        .map { Tamagotchi(kind: $0, level: 6) })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        configureUI()
        bind()
    }
    
    private func configureNavigation() {
        navigationItem.title = "다마고치 선택하기"
    }
    
    private func configureUI() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func bind() {
        tamagotchi
            .bind(to: collectionView.rx.items(cellIdentifier: TamagotchiCollectionViewCell.identifier, cellType: TamagotchiCollectionViewCell.self)) { row, tamagotchi, cell in
                cell.tamagotchiView.configure(with: tamagotchi)
            }
            .disposed(by: disposeBag)
    }
}
