//
//  CustomObservable.swift
//  Tamagotchi
//
//  Created by 금가경 on 8/25/25.
//

import Alamofire
import Foundation
import RxSwift

class CustomObservable {
    static func getLotto(query: String) -> Observable<Lotto> {
        Observable.create { observer in
            let url = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(query)"
            
            AF.request(url)
                .responseDecodable(of: Lotto.self) { response in
                    switch response.result {
                    case .success(let lotto):
                        observer.onNext(lotto)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            return Disposables.create()
        }
    }
}
