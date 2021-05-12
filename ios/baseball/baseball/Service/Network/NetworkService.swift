//
//  NetworkService.swift
//  baseball
//
//  Created by 이다훈 on 2021/05/04.
//

import Foundation
import RxSwift
import Alamofire
import RxAlamofire

protocol NetworkServiceable {
    func get<T: Codable>(path: APIPath, id: String?) -> Observable<T>
    func post(path: APIPath, id: String, selectedTeam: String) -> Observable<Int?>
    func postEnterGame(id: String, selectedTeam: String, completionHandler: @escaping (Int) -> ())
}

class NetworkService: NetworkServiceable {
    func get<T: Codable>(path: APIPath, id: String? = nil) -> Observable<T> {
        return Observable<T>.create({ observer in
            let endPoint = EndPoint.init(method: .get, path: path, id: id)
            
            var request : URLRequest {
                
                do {
                    let request = try endPoint.asURLRequest()
                    return request
                } catch {
                    assertionFailure("NetworkService.get.request")
                }
                return URLRequest.init(url: URL(string: "")!)
            }
            
            let dataRequest = AF.request(request)
            
            dataRequest.responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let model : T = try JSONDecoder().decode(T.self, from: data)
                        observer.onNext(model)
                    } catch  {
                        assertionFailure("NetworkService.get.dataRequest.responseData. case: .success")
                    }
                    
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create {
                dataRequest.cancel()
            }
        })
    }
    
    func post(path: APIPath, id: String, selectedTeam: String) -> Observable<Int?> {
        let path = "\"\(path)"
        let parameters: [String: Any] = ["id": id, "selectedTeam": selectedTeam]

        return RxAlamofire
            .request(.post, path, parameters: parameters)
            .debug()
            .observe(on: ConcurrentDispatchQueueScheduler.init(qos: .default))
            .response()
            .map({ result in
                return result.statusCode
            })
    }
    
    func postEnterGame(id: String, selectedTeam: String, completionHandler: @escaping (Int) -> ()) {
        let parameters: [String: Any] = ["id": id, "selectedTeam": selectedTeam]
        guard let url = EndPoint(method: .post, path: .match, id: .none).url else { return }
        
        AF.request(url, parameters: parameters).response { response in
            completionHandler(response.response?.statusCode ?? 400)
        }
    }
}
