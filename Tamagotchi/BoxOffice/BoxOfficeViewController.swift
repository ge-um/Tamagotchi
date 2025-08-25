//
//  BoxOfficeViewController.swift
//  Tamagotchi
//
//  Created by 금가경 on 8/25/25.
//

import UIKit
import RxCocoa
import RxSwift

final class BoxOfficeViewController: BaseViewController {
    let searchBar: UISearchBar = {
       let searchBar = UISearchBar()
        searchBar.placeholder = "yyyyMMdd를 입력하세요."
        return searchBar
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private let list: BehaviorRelay<[String]> = BehaviorRelay(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
    }
    
    private func configureUI() {
        view.addSubview(searchBar)
        view.addSubview(tableView)
        
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func bind() {
        list
            .bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) { row, element, cell in
                cell.textLabel?.text = element
            }
            .disposed(by: disposeBag)
        
        searchBar.rx.searchButtonClicked
            .withLatestFrom(searchBar.rx.text.orEmpty)
            .distinctUntilChanged()
            .flatMap { date in
                CustomObservable.getMovieTitle(date: date)
            }
            .subscribe(with: self, onNext: { owner, movies in
                owner.list.accept(movies.map { $0.movieNm })
            })
            .disposed(by: disposeBag)
    }
}
