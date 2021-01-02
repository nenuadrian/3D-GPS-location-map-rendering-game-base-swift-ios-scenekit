//
//  API.swift
//  HW
//
//  Created by Adrian Nenu on 28/03/2017.
//  Copyright © 2017 Adrian Nenu. All rights reserved.
//

import Foundation


class API {
    
    static func get(endpoint: String, callback: @escaping (_: JSON) -> Void) {
        APIHelper.get(path: endpoint, params: nil, completion: { (_, j) in
                    callback(j!)
                })
    }
   
}
