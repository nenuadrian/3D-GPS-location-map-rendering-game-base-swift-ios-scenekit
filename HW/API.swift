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
    private static var token: String = ""
    
    static func setToken(token: String) {
        API.token = token.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        UserDefaults.standard.setValue(token, forKey: "token")
        UserDefaults.standard.synchronize()
    }
    
    static func deleteToken() {
        setToken(token: "")
        UserDefaults.standard.removeObject(forKey: "token")
        UserDefaults.standard.synchronize()
    }
    
    static func getToken() -> String {
        return token
    }
    
    // TODO on auth error logout
    static func request(method: HTTPVerb, params: [String : Any]? = nil, endpoint: String, callback: @escaping (_: JSON) -> Void) {
        do {
            Logging.info(data: "REQUEST: \(endpoint) \(String(describing: params))")

            let url = "\(Constants.REST_HOST)\(endpoint)?token=\(token)&lat=\(LocationMaster.getLast().x)&lon=\(LocationMaster.getLast().y)&c=\(Utils.timestamp())"
            let opt = try HTTP.New(url, method: method, parameters: params, requestSerializer: JSONParameterSerializer(), isDownload: false)
          
            opt.start { response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                    return //also notify app of failure as needed
                }
                
                let json = JSON(data: response.data)
                
                if json["code"].int! == 402 {
                    print("ATH ERROR")
                    return
                }
                
                let action = json["data"]["action"]
                if !action.isEmpty {
                    if !action["task"].isEmpty {
                        DispatchQueue.main.async {
                            Cardinal.player.taskManager.addTask(task: Task(task: action["task"]))
                        }
                    }
                    
                    if !action["drop"].isEmpty {
                        DispatchQueue.main.async {
                            DropInterface().show(items: action["drop"])
                        }
                    }
           
                    if let add = json["data"]["action"]["add"].dictionary {
                        if let apps = add["apps"]?.array {
                            apps.forEach { (a) in Cardinal.player.apps.add(app: App(data: a))  }
                        }
                        
                        if let items = add["items"]?.array {
                            items.forEach { (i) in Cardinal.player.inventory.add(item: Item(data: i)) }
                        }
                    }
                    
                    if let remove = json["data"]["action"]["remove"].dictionary {
                        if let apps = remove["apps"]?.array {
                            apps.forEach { (a) in Cardinal.player.apps.remove(id: a.string!) }
                        }
                        
                        if let items = remove["items"]?.array {
                            items.forEach { (i) in Cardinal.player.inventory.remove(item: Item(data: i)) }
                        }
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
    
    static func post(endpoint: String, params: [String : Any]? = nil, callback: @escaping (_: JSON) -> Void) {
        request(method: .POST, params: params, endpoint: endpoint, callback: callback)
    }
}
