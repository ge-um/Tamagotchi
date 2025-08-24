//
//  SelectDetailViewController.swift
//  Tamagotchi
//
//  Created by 금가경 on 8/24/25.
//

import SnapKit
import RxCocoa
import RxSwift
import UIKit

final class SelectDetailViewController: BaseViewController {
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue1
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var tamagotchiView: TamagotchiView = {
        let view = TamagotchiView()
        return view
    }()
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = .accent
        return view
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        
        var config = UIButton.Configuration.plain()
        config.title = "취소"
        config.background.strokeColor = .systemGray4
        config.background.strokeWidth = 1
        config.background.cornerRadius = 0
        config.baseForegroundColor = .accent
        
        button.configuration = config
        return button
    }()
    
    private let startButton: UIButton = {
        let button = UIButton()
        
        var config = UIButton.Configuration.plain()
        config.title = "시작하기"
        config.background.strokeColor = .systemGray4
        config.background.strokeWidth = 1
        config.background.cornerRadius = 0
        config.baseForegroundColor = .accent
        
        button.configuration = config
        return button
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
        
    private let viewModel: SelectDetailViewModel
    
    init(tamagotchi: Tamagotchi) {
        viewModel = SelectDetailViewModel(tamagotchi: tamagotchi)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
    }
    
    private func configureUI() {
        view.backgroundColor = .black.withAlphaComponent(0.5)
        
        view.addSubview(containerView)
        containerView.addSubview(tamagotchiView)
        containerView.addSubview(line)
        containerView.addSubview(messageLabel)
        
        stackView.addArrangedSubview(cancelButton)
        stackView.addArrangedSubview(startButton)

        containerView.addSubview(stackView)
        
        containerView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(40)
            make.verticalEdges.equalTo(view.safeAreaLayoutGuide).inset(180)
        }
        
        tamagotchiView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(40)
            make.horizontalEdges.equalToSuperview().inset(100)
        }
        
        line.snp.makeConstraints { make in
            make.top.equalTo(tamagotchiView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(1)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(line.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        stackView.snp.makeConstraints { make in
            make.height.equalTo(52)
            make.bottom.horizontalEdges.equalToSuperview()
        }
    }
    
    private func bind() {
        let input = SelectDetailViewModel.Input(startTap: startButton.rx.tap.asObservable(), cancelTap: cancelButton.rx.tap.asObservable())
        let output = viewModel.transform(input: input)
        
        output.tamagotchi
            .asDriver(onErrorJustReturn: Tamagotchi(kind: .none, level: 0))
            .drive(with: self) { owner, tamagotchi in
                owner.tamagotchiView.configure(with: tamagotchi)
                owner.messageLabel.text = tamagotchi.message
            }
            .disposed(by: disposeBag)
        
        output.changeRoot
            .asDriver(onErrorJustReturn: Tamagotchi(kind: .one, level: 1))
            .drive(with: self) { owner, tamagotchi in
                let mainVc = MainViewController()
                mainVc.tamagotchi = tamagotchi
                let vc = UINavigationController(rootViewController: mainVc)
                
                if let sceneDelegate = UIApplication.shared.connectedScenes
                    .first?.delegate as? SceneDelegate,
                   let window = sceneDelegate.window {
                    window.rootViewController = vc
                    window.makeKeyAndVisible()
                }
            }
            .disposed(by: disposeBag)
        
        output.dismiss
            .asSignal(onErrorJustReturn: ())
            .emit(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
}
