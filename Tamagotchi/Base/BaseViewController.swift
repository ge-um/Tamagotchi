//
//  BaseViewController.swift
//  Tamagotchi
//
//  Created by 금가경 on 8/22/25.
//

import RxSwift
import UIKit

class BaseViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue1
    }
}
