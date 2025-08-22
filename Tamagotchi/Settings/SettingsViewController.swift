//
//  SettingsViewController.swift
//  Tamagotchi
//
//  Created by 금가경 on 8/22/25.
//

import SnapKit
import RxCocoa
import RxSwift
import UIKit

final class SettingsViewController: BaseViewController {
    let tableView: UITableView = {
       let tableView = UITableView()
        tableView.rowHeight = 52
        tableView.backgroundColor = .clear
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.identifier)

        return tableView
    }()
    
    private let disposeBag = DisposeBag()
    private let viewModel = SettingsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
    }
    
    private func configureUI() {
        navigationItem.title = "설정"
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func bind() {
        let input = SettingsViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.items
            .drive(tableView.rx.items(cellIdentifier: SettingsTableViewCell.identifier, cellType: SettingsTableViewCell.self)) { row, element, cell in
                cell.configure(with: element)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .map { $0.row }
            .bind(with: self) { owner, row in
                
                if row == 0 {
                    let vc = UIViewController()
                    vc.view.backgroundColor = .blue1
                    vc.title = "대장님 이름 정하기"
                    owner.navigationController?.pushViewController(vc, animated: true)
                }
            }
            .disposed(by: disposeBag)
    }
}
