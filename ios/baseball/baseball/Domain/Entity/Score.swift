//
//  Score.swift
//  baseball
//
//  Created by 이다훈 on 2021/05/07.
//

import Foundation

struct ScoreInfo: Codable {
    private (set) var homeName: String
    private (set) var awayName: String
    private (set) var awayScore: Int
    private (set) var homeScore: Int
}
