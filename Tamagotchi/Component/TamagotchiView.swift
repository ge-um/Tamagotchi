//
//  TamagotchiView.swift
//  Tamagotchi
//
//  Created by 금가경 on 8/23/25.
//

import SnapKit
import UIKit
import RxSwift
import RxCocoa

final class TamagotchiView: UIStackView {
    private lazy var tamagotchiImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .accent
        label.layer.cornerRadius = 4
        label.layer.borderColor = UIColor.accent.cgColor
        label.layer.borderWidth = 1
        label.textAlignment = .center
        return label
    }()
    
    var tamagotchi = Tamagotchi(kind: .one, level: 1) {
        didSet {
            configure(with: tamagotchi)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureUI()
        configure(with: tamagotchi)
    }
    
    init(tamagotchi: Tamagotchi) {
        self.tamagotchi = tamagotchi
        super.init(frame: .zero)
        configureUI()
        configure(with: tamagotchi)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        axis = .vertical
        spacing = 12
        distribution = .fill
        alignment = .center
        
        addArrangedSubview(tamagotchiImageView)
        addArrangedSubview(nameLabel)
        
        tamagotchiImageView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(tamagotchiImageView.snp.width).multipliedBy(1)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.height.equalTo(32)
            make.width.equalTo(116)
        }
    }
    
    func configure(with data: Tamagotchi) {
        tamagotchiImageView.image = UIImage(named: data.imageName)
        nameLabel.text = data.name
    }
        
    func updateImage(with data: Tamagotchi) {
        tamagotchiImageView.image = UIImage(named: data.imageName)
    }
}
