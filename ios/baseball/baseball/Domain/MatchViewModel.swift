//
//  MatchViewModel.swift
//  baseball
//
//  Created by zombietux on 2021/05/07.
//

import Foundation
import RxSwift

class MatchViewModel {
    private(set) var matchs = BehaviorSubject<[Match]>(value: [])
    private var matchUseCase: MatchUseCasePort!
    private(set) var id: Observable<String>?
    private var disposeBag = DisposeBag()
    
    init(matchUseCase: MatchUseCasePort = MatchUseCase()) {
        self.matchUseCase = matchUseCase
        self.fetchMatchs()
    }
    
    private func fetchMatchs() {
        matchUseCase.get(path: .match, id: nil)
            .take(1)
            .bind(to: matchs)
    }
    
    func enterGame(id: String, selectedTeam: String, completionHandler: @escaping (Int) -> ()) {
        return matchUseCase.enterGame(id: id, selectedTeam: selectedTeam) { statusCode in
            completionHandler(statusCode)
        }
    }
}
