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
    var type: Int
    
    init(type: Int) {
        self.type = type
    }
    
    convenience init(data: JSON) {
        self.init(type: data["type"].int!)
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
