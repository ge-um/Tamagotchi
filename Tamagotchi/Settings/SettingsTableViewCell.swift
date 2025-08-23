//
//  SettingsTableViewCell.swift
//  Tamagotchi
//
//  Created by 금가경 on 8/22/25.
//

import RxSwift
import RxCocoa
import UIKit

final class SettingsTableViewCell: UITableViewCell, IsIdentifiable {
    private let icon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "pencil")
        return imageView
    }()
    
    private let itemTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .bold)
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .light)
        label.textColor = .accent
        return label
    }()
    
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 12
        return stackView
    }()
    
    private let disposeBag = DisposeBag()

    // TODO: - cell에서 prepareForReuse를 안 써도 네비게이션이 중첩안되는 이유는 뭘까?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        backgroundColor = .clear
        
        containerStackView.addArrangedSubview(icon)
        containerStackView.addArrangedSubview(itemTitle)
        containerStackView.addArrangedSubview(nameLabel)
        
        contentView.addSubview(containerStackView)
        
        icon.snp.makeConstraints { make in
            make.size.equalTo(20)
        }
        
        itemTitle.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(100)
        }
        
        containerStackView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(12)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        accessoryType = .disclosureIndicator
    }
    
    func configure(row: Int, with data: Setting) {
        icon.image = UIImage(systemName: data.icon)
        itemTitle.text = data.title
        
        if row == 0 {
            nameLabel.text = UserDefaults.standard.string(forKey: .name) ?? "대장"
        }
    }
}
