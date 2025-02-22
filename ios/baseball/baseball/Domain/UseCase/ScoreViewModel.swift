//
//  ScoreViewModel.swift
//  baseball
//
//  Created by zombietux on 2021/05/10.
//

import Foundation
import RxSwift

class ScoreViewModel {
    private(set) var gameInfo = BehaviorSubject<GameInfo>(value: GameInfo())
    private var scoreUseCase: UseCasePort!
    lazy private(set) var scores = gameInfo.map {
        $0.scores
    }
    
    lazy private(set) var inningsScore = gameInfo.map {
        $0.innings
    }
    
    lazy private(set) var homeBatters = gameInfo.map {
        $0.homePlayers.batters
    }
    
    lazy private(set) var awayBatters = gameInfo.map {
        $0.awayPlayers.batters
    }
    
    init(scoreUseCase: UseCasePort = ScoreUseCase(), id: String) {
        self.scoreUseCase = scoreUseCase
        self.fetchGameInfo(id: id)
    }
    
    private func fetchGameInfo(id: String) {
        scoreUseCase.get(path: .gameInfo, id: id)
            .debug()
            .bind(to: gameInfo)
    }
}
