//
//  InputOutput.swift
//  Tamagotchi
//
//  Created by 금가경 on 8/22/25.
//

import Foundation

protocol InputOutput {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
