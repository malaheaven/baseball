//
//  PlayUseCase.swift
//  baseball
//
//  Created by zombietux on 2021/05/09.
//

import Foundation
import RxSwift

protocol PlayUseCasePort {
    func get<T: Codable>(path: APIPath, id: String?) -> Observable<T>
    func requestPitch<T: Codable>(id: String) -> Observable<T>
}

class PlayUseCase: PlayUseCasePort {
    private var networkService: NetworkServiceable
    
    init(networkService: NetworkServiceable = NetworkService()) {
        self.networkService = networkService
    }
    
    func get<T>(path: APIPath, id: String?) -> Observable<T> where T : Decodable, T : Encodable {
        return networkService.get(path: .progress, id: id)
    }
    
    func requestPitch<T>(id: String) -> Observable<T> where T : Decodable, T : Encodable {
        return networkService.requestPitch(path: .progress, id: id)
    }
}
