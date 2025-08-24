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
        let input = SettingsViewModel.Input(itemSelected: tableView.rx.itemSelected)
        let output = viewModel.transform(input: input)
        
        output.items
            .drive(tableView.rx.items(cellIdentifier: SettingsTableViewCell.identifier, cellType: SettingsTableViewCell.self)) { row, element, cell in
                cell.configure(row: row, with: element)
            }
            .disposed(by: disposeBag)
        
        output.nextViewController
            .drive(with: self) { owner, row in
                if row == 0 {
                    let vc = NameViewController()
                    owner.navigationController?.pushViewController(vc, animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx
            .notification(UserDefaults.didChangeNotification)
            .map { _ in UserDefaults.standard.string(forKey: .name) }
            .subscribe(with: self) { owner, _ in
                owner.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .bind(with: self) { owner, indexPath in
                if indexPath.row == 1 {
                    let vc = SelectViewController()
                    owner.navigationController?.pushViewController(vc, animated: true)
                } else if indexPath.row == 2 {
                    let alert = UIAlertController(title: "데이터 초기화", message: "정말 다시 처음부터 시작하실 건가용?", preferredStyle: .alert)
                    
                    let cancel = UIAlertAction(title: "아냐!", style: .cancel)
                    cancel.setValue(UIColor.systemBlue, forKey: "titleTextColor")
                    
                    let confirm = UIAlertAction(title: "웅", style: .default) { _ in
                        UserDefaults.standard.removeObject(forKey: .name)
                        UserDefaults.standard.removeObject(forKey: .water)
                        UserDefaults.standard.removeObject(forKey: .meal)
                        
                        let vc = UINavigationController(rootViewController: SelectViewController())
                        
                        if let sceneDelegate = UIApplication.shared.connectedScenes
                            .first?.delegate as? SceneDelegate,
                           let window = sceneDelegate.window {
                            window.rootViewController = vc
                            window.makeKeyAndVisible()
                        }
                    }
                    confirm.setValue(UIColor.systemBlue, forKey: "titleTextColor")

                    alert.addAction(cancel)
                    alert.addAction(confirm)
                    
                    owner.present(alert, animated: true)
                }
            }
            .disposed(by: disposeBag)
    }
}
