//
//  FeedView.swift
//  Tamagotchi
//
//  Created by 금가경 on 8/23/25.
//

import SnapKit
import UIKit

enum FeedType: String {
    case meal = "밥"
    case water = "물"
    
    var placeholder: String {
        return rawValue + "주세용"
    }
    
    var buttonText: String {
        return rawValue + "먹기"
    }
    
    var buttonImage: String {
        switch self {
        case .meal:
            return "drop.circle"
        case .water:
            return "leaf.circle"
        }
    }
}

final class FeedView: UIView {
    lazy var textField: UITextField = {
       let textField = UITextField()
        textField.placeholder = type.placeholder
        textField.textAlignment = .center
        return textField
    }()
    
    private let line: UIView = {
       let view = UIView()
        view.backgroundColor = .accent
        return view
    }()
    
    lazy var feedButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.bordered()
        
        config.image = UIImage(systemName: type.buttonImage)
        config.baseForegroundColor = .accent
        config.baseBackgroundColor = .clear
        config.title = type.buttonText
        config.background.cornerRadius = 10
        config.background.strokeColor = .accent
        config.background.strokeWidth = 1
        
        button.configuration = config
        
        return button
    }()
    
    let type: FeedType
    
    init(type: FeedType) {
        self.type = type
        super.init(frame: .zero)
        
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        addSubview(textField)
        addSubview(line)
        addSubview(feedButton)
        
        textField.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.trailing.equalTo(feedButton.snp.leading).offset(-12)
        }
        
        line.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom)
            make.leading.bottom.equalToSuperview()
            make.trailing.equalTo(feedButton.snp.leading).offset(-12)
            make.height.equalTo(1)
        }
        
        feedButton.snp.makeConstraints { make in
            make.centerY.equalTo(textField.snp.centerY)
            make.top.trailing.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(100)
        }
    }
}
