//
//  TamagotchiCollectionViewCell.swift
//  Tamagotchi
//
//  Created by 금가경 on 8/24/25.
//

import SnapKit
import UIKit

final class TamagotchiCollectionViewCell: UICollectionViewCell, IsIdentifiable {
    lazy var tamagotchiView = TamagotchiView(tamagotchi: tamagotchi)
    
    var tamagotchi = Tamagotchi(kind: .one, level: 1)
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        contentView.addSubview(tamagotchiView)
        
        tamagotchiView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
