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
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14)
        label.textColor = .accent
        return label
    }()
    
    private let bubbleView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bubble")
        return imageView
    }()
    
    private let messageBubbleView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let tamagotchiView = TamagotchiView()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .accent
        return label
    }()
    
    private let mealView = FeedView(type: .meal)
    private let waterView = FeedView(type: .water)
    
    private let feedStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.distribution = .fill
        return stackView
    }()
    
    private let viewModel: MainViewModel
    
    init(tamagotchi: Tamagotchi) {
        viewModel = MainViewModel(tamagotchi: tamagotchi)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        configureUI()
        bind()
    }
    
    private func configureNavigation() {
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.circle"))
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    private func configureUI() {
        messageBubbleView.addSubview(messageLabel)
        messageBubbleView.addSubview(bubbleView)
        view.addSubview(messageBubbleView)
        
        view.addSubview(tamagotchiView)
        view.addSubview(statusLabel)
        
        feedStackView.addArrangedSubview(mealView)
        feedStackView.addArrangedSubview(waterView)
        view.addSubview(feedStackView)
        
        messageLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        bubbleView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        messageBubbleView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(44)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(80)
            make.height.equalTo(152)
        }
        
        tamagotchiView.snp.makeConstraints { make in
            make.top.equalTo(messageBubbleView.snp.bottom)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(88)
        }
        
        statusLabel.snp.makeConstraints { make in
            make.top.equalTo(tamagotchiView.snp.bottom).offset(12)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }

        feedStackView.snp.makeConstraints { make in
            make.top.equalTo(statusLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(44)
        }
    }
    
    private func bind() {
        let input = MainViewModel.Input(
            viewWillAppear: rx.methodInvoked(#selector(viewWillAppear)).map { _ in },
            rightBarButtonTapped: navigationItem.rightBarButtonItem!.rx.tap.asObservable(),
            addMeal: mealView.feedButton.rx.tap
                .withLatestFrom(mealView.textField.rx.text.orEmpty),
            addWater: waterView.feedButton.rx.tap
                .withLatestFrom(waterView.textField.rx.text.orEmpty)
        )
        
        let output = viewModel.transform(input: input)
        
        output.tamagotchi
            .bind(with: self) { owner, tamagotchi in
                owner.tamagotchiView.configure(with: tamagotchi)
            }
            .disposed(by: disposeBag)
        
        output.title
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        output.message
            .bind(to: messageLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.status
            .bind(to: statusLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.navigateToSettings
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                let vc = SettingsViewController()
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
}
