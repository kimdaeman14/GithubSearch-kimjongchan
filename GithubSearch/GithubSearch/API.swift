//
//  API.swift
//  SVmiOS
//
//  Created by Jaycee on 2020/01/19.
//  Copyright © 2020 Jaycee. All rights reserved.
//

import Alamofire
import SwiftyJSON


//https://api.github.com/users?since=100
//https://api.github.com/users/kimdaeman14
//https://api.github.com/users/kimdaeman14/repos?per_page=10
//https://api.github.com/users/kimdaeman14/repos?page=1
//https://api.github.com/users/mojombo/repos?page=1



//https://api.github.com/search/users?q=tom
//https://api.github.com/users/kimdaeman14



protocol APIProtocol {
    static func allUsers(_ since:Int) -> DataRequest
    static func profileInfo(_ name:String) -> DataRequest
    static func reposList(_ page:Int, _ name:String) -> DataRequest
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
    
    
    
    
    static func searchUsers(_ q: String, _ page:Int) -> DataRequest {
        
//        https://api.github.com/search/users?q=Kim&client_id=0578bf8be1c2f1b87b02&client_secret=7df154ac4b5507906f35358e5847fa99222f0c3a
        
        
//        https://api.github.com/search/users?q=tom&page=1&client_id=0578bf8be1c2f1b87b02&client_secret=7df154ac4b5507906f35358e5847fa99222f0c3a
        
        
        let url = URL(string: API.Address.search.url.absoluteString + "/users?q=\(q)" + "&page=\(page)" + "&client_id=\(API.clientID)&client_secret=\(API.clidentSecret)") ?? URL.init(fileURLWithPath: "")
        
        print(url)
        
        return request(url: url, method: .get, parameters: [:])
    }
    
    static func detailUserInfos(_ userName: String) -> DataRequest {
//        let url = URL(string: API.Address.users.url.absoluteString + "/\(userName)" ) ?? URL.init(fileURLWithPath: "")
        
        let url = URL(string: API.Address.users.url.absoluteString + "/\(userName)" + "?client_id=\(API.clientID)&client_secret=\(API.clidentSecret)" ) ?? URL.init(fileURLWithPath: "")

//        print(url)
        
//
        
//        https://api.github.com/users/whatever?client_id=0578bf8be1c2f1b87b02&client_secret=7df154ac4b5507906f35358e5847fa99222f0c3a
        
        
        
        
        return request(url: url, method: .get, parameters: [:])

        
    }
    
    
    
    
    
    // MARK: - API Endpoint Requests
    static func allUsers(_ since: Int) -> DataRequest {
        let url = URL(string: API.Address.users.url.absoluteString + "?since=\(since)") ?? URL.init(fileURLWithPath: "")
        return request(url: url, method: .get, parameters: [:])
    }
    
    static func profileInfo(_ name: String) -> DataRequest {
        let url = URL(string: API.Address.users.url.absoluteString + "/\(name)") ?? URL.init(fileURLWithPath: "")
        print(url,"url11")
        return request(url: url, method: .get, parameters: [:])
    }
    
    static func reposList(_ page: Int,_ name: String) -> DataRequest {
        let url = URL(string: API.Address.users.url.absoluteString + "/\(name)/repos?page=\(page)") ?? URL.init(fileURLWithPath: "")
        print(url,"url3333")
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

