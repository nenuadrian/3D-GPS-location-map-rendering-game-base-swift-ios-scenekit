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
    static let host = "http://192.168.0.103:3001/"
    private static var token: String = ""
    
    static func setToken(token: String) {
        API.token = token.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    static func request(method: HTTPVerb, params: [String : Any], endpoint: String, callback: @escaping (_: JSON) -> Void) {
        do {
            let url = "\(host)\(endpoint)?token=\(token)&lat=\(LocationMaster.getLast().x)&lon=\(LocationMaster.getLast().y)"
            print(url)

            let opt = try HTTP.New(url, method: method, parameters: params, requestSerializer: JSONParameterSerializer(), isDownload: false)
          
            opt.start { response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                    return //also notify app of failure as needed
                }
                
                let json = JSON(data: response.data)
                if json["data"]["action"] != JSON.null {
                    if json["data"]["action"]["task"] != JSON.null {
                        TasksManager.addTask(task: Task(task: json["data"]["action"]["task"]))
                    }
                    
                    if json["data"]["action"]["drop"] != JSON.null {
                        GUIMaster.drop(data: json["data"]["action"]["drop"])
                    }
                
                    if json["data"]["action"]["item"] != JSON.null {
                        Inventory.add(item: Item(data: json["data"]["action"]["item"]))
                    }
                    
                    if json["data"]["action"]["app"] != JSON.null {
                        Apps.apps.append(App(data: json["data"]["action"]["app"]))
                    }
                }
                
                callback(json)
            }

        } catch let error {
            print("got an error creating the request: \(error)")
        }
    }
    
    static func get(endpoint: String, callback: @escaping (_: JSON) -> Void) {
        request(method: .GET, params: [:], endpoint: endpoint, callback: callback)
    }
    
    static func put(endpoint: String, callback: @escaping (_: JSON) -> Void) {
        request(method: .PUT, params: [:], endpoint: endpoint, callback: callback)
    }
    
    static func post(endpoint: String, callback: @escaping (_: JSON) -> Void) {
        request(method: .POST, params: [:], endpoint: endpoint, callback: callback)
    }
    
    static func post(endpoint: String, params: [String : Any], callback: @escaping (_: JSON) -> Void) {
        request(method: .POST, params: params, endpoint: endpoint, callback: callback)
    }
}
