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
    
    static func request(method: HTTPVerb, params: [String : Any]? = nil, endpoint: String, callback: @escaping (_: JSON) -> Void) {
        Logging.info(data: "REQUEST: \(endpoint) \(String(describing: params))")

        let opt = HTTP.New(endpoint, method: method, parameters: params, requestSerializer: JSONParameterSerializer())

        opt?.run { response in
            if let err = response.error {
                print("error: \(err.localizedDescription)")
                return //also notify app of failure as needed
            }
            
            do {
                let json = try JSON(data: response.data)
            
                callback(json)
            } catch let error {
                print("got an error creating the request: \(error)")
            }
        }

       
    }
    
    static func get(endpoint: String, callback: @escaping (_: JSON) -> Void) {
        request(method: .GET, params: [:], endpoint: endpoint, callback: callback)
    }
   
}
