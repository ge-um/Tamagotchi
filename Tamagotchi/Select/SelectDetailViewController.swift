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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .black.withAlphaComponent(0.5)
        view.addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(40)
            make.verticalEdges.equalTo(view.safeAreaLayoutGuide).inset(180)
        }
    }
}
