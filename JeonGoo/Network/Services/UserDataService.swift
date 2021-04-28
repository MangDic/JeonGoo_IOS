//
//  UserDataService.swift
//  JeonGoo
//
//  Created by 이명직 on 2021/04/28.
//

import Foundation
import Moya

class UserDataService {
    
    fileprivate let provider = MoyaProvider<UserService>(endpointClosure: { (target: UserService) -> Endpoint in
        let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
        switch target {
        default:
            let httpHeaderFields = ["Content-Type" : "application/json"]
            return defaultEndpoint.adding(newHTTPHeaderFields: httpHeaderFields)
        }
    })
    
    func signInPost(email: String, pass: String, completion: @escaping ((Post?, Error?) -> Void)) {
        provider.request(.signin(email: email, password: pass)) { result in
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let post = try decoder.decode(Post.self, from: response.data)
                    completion(post, nil)
                }
                catch (let error) {
                    completion(nil, error)
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func signUpPost(email: String, password: String, name: String, number: String, gender: String, address: String, detailAddress: String, completion: @escaping ((Post?, Error?) -> Void)) {
        provider.request(.signup(email: email, password: password, name: name, number: number, gender: gender, address: address, detailAddress: detailAddress)) { result in
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let post = try decoder.decode(Post.self, from: response.data)
                    completion(post, nil)
                }
                catch (let error) {
                    completion(nil, error)
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}