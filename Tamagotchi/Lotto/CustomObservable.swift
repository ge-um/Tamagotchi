//
//  CustomObservable.swift
//  Tamagotchi
//
//  Created by 금가경 on 8/25/25.
//

import Alamofire
import Foundation
import RxSwift

struct BoxOfficeResponse: Decodable {
    let boxOfficeResult: BoxOfficeResult
}

struct BoxOfficeResult: Decodable {
    let dailyBoxOfficeList: [Movie]
}

struct Movie: Decodable {
    let movieNm: String
}

//success("{\"boxOfficeResult\":{\"boxofficeType\":\"일별 박스오피스\",\"showRange\":\"20201201~20201201\",\"dailyBoxOfficeList\":[{\"rnum\":\"1\",\"rank\":\"1\",\"rankInten\":\"0\",\"rankOldAndNew\":\"OLD\",\"movieCd\":\"20181983\",\"movieNm\":\"이웃사촌\",\"openDt\":\"2020-11-25\",\"salesAmt\":\"127434060\",\"salesShare\":\"38.6\",\"salesInten\":\"-41021220\",\"salesChange\":\"-24.4\",\"salesAcc\":\"2007994920\",\"audiCnt\":\"15609\",\"audiInten\":\"-5047\",\"audiChange\":\"-24.4\",\"audiAcc\":\"236545\",\"scrnCnt\":\"1202\",\"showCnt\":\"3312\"},

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
    
    static func getMovieTitle(date: String) -> Observable<[Movie]> {
        Observable.create { observer in
            let url = "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=\(API.key)&targetDt=\(date)"
            
            AF.request(url)
                .responseDecodable(of: BoxOfficeResponse.self) { response in
                    switch response.result {
                    case .success(let boxOfficeResponse):
                        let movieNames = boxOfficeResponse.boxOfficeResult.dailyBoxOfficeList
                        observer.onNext(movieNames)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            return Disposables.create()
        }
    }
}
