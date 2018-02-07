//
//  Logging.swift
//  HW
//
//  Created by Adrian Nenu on 06/04/2017.
//  Copyright © 2017 Adrian Nenu. All rights reserved.
//

import Foundation

class Logging {
    static func out(type: String, data: String) {
        print("[\(type.uppercased())] \(data)")
    }
    
    static func info(data: String) {
        out(type: "info", data: data)
    }
}
