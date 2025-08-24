//
//  Setting.swift
//  Tamagotchi
//
//  Created by 금가경 on 8/22/25.
//

import Foundation

struct Setting {
    let icon: String
    let title: String
    
    init(icon: String, title: String) {
        self.icon = icon
        self.title = title
    }
    
    static let list = [
        Setting(icon: "pencil", title: "내 이름 설정하기"),
        Setting(icon: "moon.fill", title: "다마고치 변경하기"),
        Setting(icon: "arrow.clockwise", title: "데이터 초기화")
    ]
}
