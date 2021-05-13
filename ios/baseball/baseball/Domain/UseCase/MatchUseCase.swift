//
//  MatchUseCase.swift
//  baseball
//
//  Created by zombietux on 2021/05/07.
//

import Foundation
import RxSwift

protocol MatchUseCasePort {
    func get<T: Codable>(path: APIPath, id: String?) -> Observable<[T]>
    func enterGame(id: String, selectedTeam: String, completionHandler: @escaping (Int) -> ())
}

class MatchUseCase: MatchUseCasePort {
    private var networkService: NetworkServiceable
    private(set) var gameEnterCode: Int = 0
    
    init(networkService: NetworkServiceable = NetworkService()) {
        self.networkService = networkService
    }

    func get<T>(path: APIPath, id: String?) -> Observable<[T]> where T : Decodable, T : Encodable {
        return networkService.get(path: .match, id: nil)
    }
   
    func enterGame(id: String, selectedTeam: String, completionHandler: @escaping (Int) -> ()) {
        networkService.postEnterGame(id: id, selectedTeam: selectedTeam) { statusCode in
            self.gameEnterCode = statusCode
            completionHandler(self.gameEnterCode)
        }
    }
}
