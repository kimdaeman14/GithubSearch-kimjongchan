//
//  Network.swift
//  GithubSearch
//
//  Created by Jaycee on 2020/01/21.
//  Copyright © 2020 Jaycee. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxAlamofire


enum EOError: Error {
  case invalidURL(String) //url이 잘못됐을때
  case invalidParameter(String, Any) //파라미터가 잘못되었을때
  case invalidJSON(String) //json이 잘못되었을때
}


class Network {
//    https://api.github.com/search/users?q=kim
//    https://api.github.com/users/kimdaeman14
//    static let API = "https://api.github.com/"
//      static let searchEndpoint = "search/users?"
//      static let usersEndpoint = "users/"

    
    
    
       
       
       
       fileprivate enum API: String {
           case searchEndpoint = "search/users?"
           case usersEndpoint = "users/"

           private var baseURL: String { return "https://api.github.com/" }
           
       }
       
    
    
    
    
    

    
    static func request(username: String) -> Observable<[String: Any]> {
        do {
            
            guard let url = URL(string: API.usersEndpoint.rawValue)?.appendingPathComponent(username) else { throw EOError.invalidURL(username)}
            
            print(data, "ddd111")

            
            
            return RxAlamofire.requestData(.get, url).map { _, data -> [String:Any] in
                
                print(data, "ddd")
                
                guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
                                        let result = jsonObject as? [String: Any] else {
                                            throw EOError.invalidJSON(url.absoluteString)
                                    }
                
                print(jsonObject, "jjjj")
                                    return result
            }

            
            
            
            
            
            
//            guard let url = URL(string: API)?.appendingPathComponent(endpoint),
//                var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
//                    throw EOError.invalidURL(endpoint)
//            }
//            components.queryItems = try query.compactMap { (key, value) in
//                guard let v = value as? CustomStringConvertible else {
//                    throw EOError.invalidParameter(key, value)
//                }
//                return URLQueryItem(name: key, value: v.description)
//            }
//
//            guard let finalURL = components.url else {
//                throw EOError.invalidURL(endpoint)
//            }
//
//            let request = URLRequest(url: finalURL)
//            return URLSession.shared.rx.response(request: request)
//                .map { _, data -> [String: Any] in
//                    guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
//                        let result = jsonObject as? [String: Any] else {
//                            throw EOError.invalidJSON(finalURL.absoluteString)
//                    }
//                    return result
//            }
            
            
            
            
        } catch {
            print("empy")
            return Observable.empty()
        }
    }
    
}
