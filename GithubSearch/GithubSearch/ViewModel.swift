////
////  ViewModel.swift
////  GithubSearch
////
////  Created by Jaycee on 2020/01/22.
////  Copyright © 2020 Jaycee. All rights reserved.
////
//
//import Foundation
//import RxSwift
//import Alamofire
//import SwiftyJSON
//import RxCocoa
//
//
//class ViewModel {
//    
//    
//    let idText = BehaviorSubject(value: "")
//    let idVaild = PublishSubject<Observable<[CustomData]>>()
//    
//    
//
//    
//
//    
//    init() {
//        
//        
//        _ = idText.distinctUntilChanged()
//        .map(request)
//        .bind(to: idVaild)
//            
//        
//        
//        
//    }
//    
//  
//    
//    
//    
//    
//    func request(_ q:String) -> Observable<[CustomData]>{
//        let url = URL(string: "https://api.github.com/search/users?q=\(q)")
//        
//        
//        
//        return Alamofire.request(url!).rx.responseData()
//            .map { _, data -> [CustomData] in
//                let jsonObject = try JSON(data: data)
//                guard let items = jsonObject["items"].array else { throw EOError.invalidURL("\(url!)") }
//                
//                return items.map { item -> CustomData in
//                    let users = CustomData(username: item["login"].string ?? "",
//                                           profileuURL: item["avatar_url"].string ?? "", repocount: "9999")
//                    
//                    return users
//                }
//                
//        }
//    }
//    
//    
//  
//    
//}
