//
//  Inventory.swift
//  HW
//
//  Created by Adrian Nenu on 04/04/2017.
//  Copyright © 2017 Adrian Nenu. All rights reserved.
//

import Foundation
import SwiftyJSON

class App {
    let id: String
    let type: Int
    let broken: Int
    
    init(type: Int, broken: Int = 0) {
        self.id = ""
        self.type = type
        self.broken = broken
    }
    
    init(id: String, type: Int, broken: Int = 0) {
        self.id = id
        self.type = type
        self.broken = broken
    }
    
    convenience init(data: JSON) {
        self.init(id: data["_id"].string!, type: data["type"].int!, broken: data["broken"] != JSON.null ? data["broken"].int! : 0)
    }
    
}

class Apps {
    static var apps: [App] = []
    
    static func add(app: App) {
        Apps.apps.append(app)
    }
    
    static func initApps(apps: JSON) {
        for a in apps.array! {
            add(app: App(data: a))
        }
    }
}
