//
//  InningInfo.swift
//  baseball
//
//  Created by zombietux on 2021/05/10.
//

import Foundation

struct InningInfo: Codable {
    private(set) var inningCount: Int
    private(set) var userTop: Bool
    private(set) var userOffense: Bool
    
    func makeUseHalf() -> String {
        return userTop ? "초" : "말"
    }
    
    func makeUserPlay() -> String {
        return userOffense ? "공격" : "수비"
    }
}
