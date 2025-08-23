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
        label.text = "복습 아직 안하셨다구요> 지금 잠이 오세여?? 대장님 ??"
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
    
    private let tamagotchiView = TamagotchiView(tamagotchi: Tamagotchi(kind: .one, level: 1))
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.text = "LV1 · 밥알 0개 · 물방울 0개"
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
    
    private let name = BehaviorRelay(value: UserDefaults.standard.string(forKey: .name))
    private let disposeBag = DisposeBag()
    
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
        
//        mealView.snp.makeConstraints { make in
//            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
//        }
//        
//        waterView.snp.makeConstraints { make in
//            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
//        }
        
        feedStackView.snp.makeConstraints { make in
            make.top.equalTo(statusLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(44)
        }
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
