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

struct Setting {
    let icon: String
    let title: String
    let detail: String
    
    init(icon: String, title: String, detail: String = "") {
        self.icon = icon
        self.title = title
        self.detail = detail
    }
    
    static let list = [
        Setting(icon: "pencil", title: "내 이름 설정하기", detail: "고래밥"),
        Setting(icon: "moon.fill", title: "다마고치"),
        Setting(icon: "arrow.clockwise", title: "데이터 초기화")
    ]
}

final class SettingsViewController: BaseViewController {
    let tableView: UITableView = {
       let tableView = UITableView()
        tableView.rowHeight = 52
        tableView.backgroundColor = .clear
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.identifier)

        return tableView
    }()
    
    private let disposeBag = DisposeBag()
    
    lazy var items = Observable.just(Setting.list)

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
        items
            .bind(to: tableView.rx.items(cellIdentifier: SettingsTableViewCell.identifier, cellType: SettingsTableViewCell.self)) { row, element, cell in
                cell.configure(with: element)
            }
            .disposed(by: disposeBag)
    }
}
