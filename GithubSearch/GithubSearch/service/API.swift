//
//  API.swift
//  SVmiOS
//
//  Created by Jaycee on 2020/01/19.
//  Copyright © 2020 Jaycee. All rights reserved.
//

import Alamofire
import SwiftyJSON


protocol APIProtocol {
    static func searchUsers(_ q: String, _ page:Int) -> DataRequest
    static func detailUserInfos(_ userName: String) -> DataRequest
}

struct API: APIProtocol {
    // MARK: - API Addresses
    fileprivate enum Address: String {
        case users = "users"
        case search = "search"
        
        private var baseURL: String { return "https://api.github.com/" }
        
        var url: URL {
            return URL(string: baseURL.appending(rawValue))!
        }
    }
    
    // MARK: - API Limit Release
    static let clientID = "0578bf8be1c2f1b87b02"
    static let clidentSecret = "7df154ac4b5507906f35358e5847fa99222f0c3a"
    
    
    // MARK: - API Endpoint Requests
    static func searchUsers(_ q: String, _ page:Int) -> DataRequest {
        let url = URL(string: API.Address.search.url.absoluteString + "/users?q=\(q)" + "&page=\(page)" + "&client_id=\(API.clientID)&client_secret=\(API.clidentSecret)") ?? URL.init(fileURLWithPath: "")
        return request(url: url, method: .get, parameters: [:])
    }
    
    static func detailUserInfos(_ userName: String) -> DataRequest {
        let url = URL(string: API.Address.users.url.absoluteString + "/\(userName)" + "?client_id=\(API.clientID)&client_secret=\(API.clidentSecret)" ) ?? URL.init(fileURLWithPath: "")
        return request(url: url, method: .get, parameters: [:])
    }
    
    // MARK: - Generic Request
    static private func request(url: URLConvertible, method:HTTPMethod, parameters: [String: Any] = [:]) -> DataRequest {
        return Alamofire.request(url,
                                 method: .get,
                                 parameters: Parameters(),
                                 encoding: URLEncoding.httpBody)
    }
    
}

