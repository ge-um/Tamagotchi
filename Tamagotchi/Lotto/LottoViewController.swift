//
//  LottoViewController.swift
//  Tamagotchi
//
//  Created by 금가경 on 8/25/25.
//

import UIKit
import SnapKit
import RxSwift

final class LottoViewController: BaseViewController {
    private let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "숫자를 입력하세요"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let button: UIButton = {
        let button = UIButton(configuration: .bordered())
        button.setTitle("버튼", for: .normal)
        return button
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
    }
    
    private func configureUI() {
        stackView.addArrangedSubview(textField)
        stackView.addArrangedSubview(button)
        stackView.addArrangedSubview(label)
        
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(40)
            make.verticalEdges.equalTo(view.safeAreaLayoutGuide).inset(280)
        }
    }
    
    private func bind() {
        button.rx.tap
            .withLatestFrom(textField.rx.text.orEmpty)
            .distinctUntilChanged()
            .flatMap { query in
                CustomObservable
                    .getLotto(query: query)
            }
            .subscribe(with: self) { owner, lotto in
                let text = lotto.numbers
                    .map { String($0) }
                    .joined(separator: " ")
                owner.label.text = text
            } onError: { owner, error in
                owner.label.text = error.localizedDescription
            }
            .disposed(by: disposeBag)
    }
}
