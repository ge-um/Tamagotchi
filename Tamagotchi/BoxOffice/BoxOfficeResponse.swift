//
//  BoxOfficeResponse.swift
//  Tamagotchi
//
//  Created by 금가경 on 8/26/25.
//

import Foundation

struct BoxOfficeResponse: Decodable {
    let boxOfficeResult: BoxOfficeResult
}

struct BoxOfficeResult: Decodable {
    let dailyBoxOfficeList: [Movie]
}

struct Movie: Decodable {
    let movieNm: String
}
