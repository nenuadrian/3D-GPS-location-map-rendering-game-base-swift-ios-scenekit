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
    let attributes: [Int]
    
    convenience init(type: Int, broken: Int = 0) {
        self.init(id: "", type: type, broken: broken)
    }
    
    init(id: String, type: Int, broken: Int = 0) {
        self.id = id
        self.type = type
        self.broken = broken
        self.attributes = (Constants.APPS[type]?.attributes)!
    }
    
    convenience init(data: JSON) {
        self.init(id: data["_id"].string!, type: data["type"].int!, broken: data["broken"] != JSON.null ? data["broken"].int! : 0)
    }
    
}

class Apps {
    private var myApps: [App] = []
    
    func apps() -> [App] {
        return myApps
    }
    
    func add(app: App) {
        myApps.append(app)
    }
    
    func remove(id: String) {
        if let index = myApps.index(where: { $0.id == id }) {
            myApps.remove(at: index)
        }
    }
    
    func initApps(apps: JSON) {
        for a in apps.array! {
            add(app: App(data: a))
        }
    }
}
