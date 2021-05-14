//
//  NetworkService.swift
//  baseball
//
//  Created by 이다훈 on 2021/05/04.
//

import Foundation
import RxSwift
import Alamofire

protocol NetworkServiceable {
    func get<T: Codable>(path: APIPath, id: String?) -> Observable<T>
    func requestPitch<T: Codable>(path: APIPath, id: String) -> Observable<T>
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
    
    func requestPitch<T: Codable>(path: APIPath, id: String) -> Observable<T> {
        return Observable<T>.create({ observer in
            let endPoint = EndPoint.init(method: .post, path: path, id: id)

            var request : URLRequest {
                do {
                    var request = try endPoint.asURLRequest()
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    let body: [String: String] = ["result" : "strike"]
                    let jsonData = try? JSONSerialization.data(withJSONObject: body)
                    request.httpBody = jsonData
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
                        let model: T = try JSONDecoder().decode(T.self, from: data)
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
    
    func postEnterGame(id: String, selectedTeam: String, completionHandler: @escaping (Int) -> ()) {
        let endPoint = EndPoint.init(method: .post, path: .match)

        var request : URLRequest {
            do {
                var request = try endPoint.asURLRequest()
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                let body: [String: String] = ["id": id, "selectedTeam": selectedTeam]
                let jsonData = try? JSONSerialization.data(withJSONObject: body)
                request.httpBody = jsonData
                return request
            } catch {
                assertionFailure("NetworkService.get.request")
            }
            return URLRequest.init(url: URL(string: "")!)
        }

        let dataRequest = AF.request(request)

        dataRequest.responseData { response in
            completionHandler(response.response?.statusCode ?? 400)
        }
    }
}
