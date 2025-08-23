//
//  MainViewController.swift
//  Tamagotchi
//
//  Created by 금가경 on 8/23/25.
//

import RxCocoa
import RxSwift
import UIKit

final class MainViewController: BaseViewController {
    
    private let name = BehaviorRelay(value: UserDefaults.standard.string(forKey: .name))
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        bind()
    }
    
    private func configureNavigation() {
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.circle"))
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    private func configureUI() {
        
    }
    
    private func bind() {
        name
            .compactMap { $0 }
            .map { "\($0)님의 다마고치" }
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        navigationItem.rightBarButtonItem?.rx.tap
            .asDriver()
            .drive(with: self) { owner, _ in
                let vc = SettingsViewController()
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
}
