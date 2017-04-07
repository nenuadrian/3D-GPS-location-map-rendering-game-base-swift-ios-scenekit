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
    private static var myApps: [App] = []
    
    static func apps() -> [App] {
        return myApps
    }
    
    static func add(app: App) {
        Apps.myApps.append(app)
    }
    
    static func remove(id: String) {
        if let index = myApps.index(where: { $0.id == id }) {
            myApps.remove(at: index)
        }
    }
    
    static func initApps(apps: JSON) {
        for a in apps.array! {
            add(app: App(data: a))
        }
    }
}
