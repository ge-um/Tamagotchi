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
    
    private let name = BehaviorRelay(value: UserDefaults.standard.string(forKey: .name) ?? "대장")
    private let meal = BehaviorRelay(value: UserDefaults.standard.string(forKey: .meal))
    private let water = BehaviorRelay(value: UserDefaults.standard.string(forKey: .water))
    
//    private lazy var message = BehaviorRelay(value: talks.randomElement()!)
//    private var talks: [String] {
//        let userName = name.value
//        return [
//            "복습 아직 안하셨다구요? 지금 잠이 오세여? \(userName)님??",
//            "테이블뷰컨트롤러와 뷰컨트롤러는 어떤 차이가 있을까요? \(userName)님?",
//            "\(userName)님 오늘 깃허브 푸시 하셨어영?",
//            "\(userName)님!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
//        ]
//    }
    
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
        let input = MainViewModel.Input(viewWillAppear: rx.methodInvoked(#selector(viewWillAppear)).map { _ in })
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
        
        navigationItem.rightBarButtonItem?.rx.tap
            .asDriver()
            .drive(with: self) { owner, _ in
                let vc = SettingsViewController()
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)

        
        // TODO: - self 떼내기
        // TODO: - refactoring
        Observable.combineLatest(meal, water)
            .compactMap { meal, water -> (Int, Int) in
                (Int(meal ?? "0")!, Int(water ?? "0")!)
            }
            .map { (meal, water) -> String in
                let calculated = meal/5 + water/2
                let level = (calculated < 1) ? 1 : min(calculated, 10)
                
//                self.tamagotchiView.tamagotchi.level = level == 10 ? 9 : level
//                self.tamagotchiView.updateImage(with: self.tamagotchi)

                return "LV\(level) · 밥알 \(meal)개 · 물방울 \(water)개"
            }
            .bind(to: statusLabel.rx.text)
            .disposed(by: disposeBag)
        
        meal
            .subscribe(onNext: { UserDefaults.standard.set($0, forKey: .meal) })
            .disposed(by: disposeBag)

        water
            .subscribe(onNext: { UserDefaults.standard.set($0, forKey: .water) })
            .disposed(by: disposeBag)

        name
            .subscribe(onNext: { UserDefaults.standard.set($0, forKey: .name) })
            .disposed(by: disposeBag)
        
//        mealView.feedButton.rx.tap
//            .withLatestFrom(mealView.textField.rx.text.orEmpty)
//            .filter { $0.allSatisfy { $0.isNumber } }
//            .compactMap { Int($0) ?? 1 }
//            .filter { $0 < 100 }
//            .subscribe(with: self) { owner, add in
//                let count = Int(owner.meal.value ?? "0")! + add
//                owner.meal.accept("\(count)")
//                owner.messageLabel.text = owner.talks.randomElement()!
//            }
//            .disposed(by: disposeBag)

//        waterView.feedButton.rx.tap
//            .withLatestFrom(waterView.textField.rx.text.orEmpty)
//            .filter { $0.allSatisfy { $0.isNumber } }
//            .compactMap { Int($0) ?? 1 }
//            .filter { $0 < 50 }
//            .subscribe(with: self) { owner, add in
//                let count = Int(owner.water.value ?? "0")! + add
//                owner.water.accept("\(count)")
//                owner.messageLabel.text = owner.talks.randomElement()!
//            }
//            .disposed(by: disposeBag)
    }
}
