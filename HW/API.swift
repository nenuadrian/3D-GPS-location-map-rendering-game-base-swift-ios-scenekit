//
//  API.swift
//  HW
//
//  Created by Adrian Nenu on 28/03/2017.
//  Copyright © 2017 Adrian Nenu. All rights reserved.
//

import Foundation
import SwiftHTTP
import SwiftyJSON

class API {
    static let host = "http://192.168.1.87:3001/"
    static var token: String = "$2a$10$4t/TH1OG90Ov10D1w6n9MeIn7h3uvJCltegydwLe8iB02Nj7We3IG".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    
    static func request(method: HTTPVerb, endpoint: String, callback: @escaping (_: JSON) -> Void) {
        do {
            let url = "\(host)\(endpoint)?token=\(token)\(LocationMaster.last != nil ? "&lat=\(LocationMaster.last.x)&long=\(LocationMaster.last.y)" : "")"
            print(url)

            let opt = try HTTP.New(url, method: method)
            opt.start { response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                    return //also notify app of failure as needed
                }
                
                let json = JSON(data: response.data)
                //print(json)
                callback(json)
            }

        } catch let error {
            print("got an error creating the request: \(error)")
        }
    }
    
    static func get(endpoint: String, callback: @escaping (_: JSON) -> Void) {
        request(method: .GET, endpoint: endpoint, callback: callback)
    }
    
    static func put(endpoint: String, callback: @escaping (_: JSON) -> Void) {
        request(method: .PUT, endpoint: endpoint, callback: callback)
    }
    
    static func post(endpoint: String, callback: @escaping (_: JSON) -> Void) {
        request(method: .POST, endpoint: endpoint, callback: callback)
    }
}
