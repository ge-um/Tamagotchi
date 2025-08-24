//
//  NameViewController.swift
//  Tamagotchi
//
//  Created by 금가경 on 8/22/25.
//

import RxCocoa
import RxSwift
import UIKit

final class NameViewController: BaseViewController {
    private let textField: UITextField = {
        let textField = UITextField()
        textField.textColor = .accent
        return textField
    }()
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = .accent
        return view
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        configureUI()
        bind()
    }
    
    private func configureNavigation() {
        navigationItem.title = "대장님 이름 정하기"
        
        let rightBarButtonItem = UIBarButtonItem()
        rightBarButtonItem.title = "저장"
        rightBarButtonItem.tintColor = .accent
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    private func configureUI() {
        view.addSubview(textField)
        view.addSubview(line)
        
        textField.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        line.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(1)
        }
    }
    
    private func bind() {
        navigationItem.rightBarButtonItem?.rx.tap
            .withLatestFrom(textField.rx.text.orEmpty)
            .filter { (2...6) ~= $0.count }
            .subscribe(with: self) { owner, name in
                UserDefaults.standard.set(name, forKey: .name)
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
}
