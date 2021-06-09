//
//  PitchInfo.swift
//  baseball
//
//  Created by zombietux on 2021/05/10.
//

import Foundation

struct PitchInfo {
    private(set) var info: [Bool]
    
    func makeSBString(at index: Int) -> String {
        return self.info[index] ? "스트라이크" : "볼"
    }
}
