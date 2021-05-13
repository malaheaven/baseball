//
//  PlayViewModel.swift
//  baseball
//
//  Created by zombietux on 2021/05/09.
//

import Foundation
import RxSwift

class PlayViewModel {
    private(set) var matchInfo = BehaviorSubject<MatchInfo>(value: MatchInfo())
    private var playUseCase: PlayUseCasePort!
    private var disposeBag = DisposeBag()
    
    lazy private(set) var pitchInfo = matchInfo.map {
        $0.pitcherInfo
    }
    
    lazy private(set) var scores = matchInfo.map {
        $0.scores
    }
    
    lazy private(set) var inningInfo = matchInfo.map {
        $0.inningInfo
    }
    
    lazy private(set) var pitcher = matchInfo.map {
        $0.pitcher
    }
    
    lazy private(set) var batter = matchInfo.map {
        $0.batter
    }
    
    lazy private(set) var sbo = matchInfo.map { matchInfo -> SBO in
        return SBO(strike: matchInfo.strike, ball: matchInfo.ball, out: matchInfo.outCount)
    }
    
    lazy private(set) var isOffense = matchInfo.map {
        $0.inningInfo.userOffense
    }
    
    lazy private(set) var bases = matchInfo.map {
        $0.bases
    }
    
    init(playUseCase: PlayUseCasePort = PlayUseCase(), id: String) {
        self.playUseCase = playUseCase
        self.fetchMatchInfo(id: id)
    }
    
    private func fetchMatchInfo(id: String) {
        playUseCase.get(path: .gameInfo, id: id)
            .debug()
            .bind(to: matchInfo)
            .disposed(by: disposeBag)
    }
    
    func requestPitch(id: String) {
        playUseCase.requestPitch(id: id)
            .debug()
            .bind(to: matchInfo)
            .disposed(by: disposeBag)
    }
}
