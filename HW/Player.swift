//
//  swift
//  HW
//
//  Created by Adrian Nenu on 28/03/2017.
//  Copyright © 2017 Adrian Nenu. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import SceneKit

class GridPointInfo {
    var tile: Vector2
    var hack_wait: IntMax
    var surge_wait: IntMax
    init(tile: Vector2, visit_wait: Int, surge_wait: Int) {
        self.tile = tile
        self.hack_wait = Utils.timestamp() + IntMax(visit_wait)
        self.surge_wait = Utils.timestamp() + IntMax(surge_wait)
    }
}

class PlayerInfo {
    let username: String
    let id: String
    
    init(id: String, username: String) {
        self.id = id
        self.username = username
    }
    
    convenience init(data: JSON) {
        self.init(id: data["id"].string!, username: data["username"].string!)
    }
}

class Player {
    let id: String
    var level: Int = 1
    var exp: Int = 0
    var group: Int = 0
    var username: String = ""
    private var homebase: Homebase!
    var grid_nodes: [GridPointInfo] = []
    let taskManager = TaskManager()
    let inventory = Inventory()
    let apps = Apps()
    
    init(data: JSON) {
        id = data["_id"].string!
        level = data["level"].int!
        exp = data["exp"].int!
        group = data["group"].int!
        username = data["username"].string!
        
        if data["home_base"] != JSON.null {
            self.newHomebase(homebase: Homebase(data: data["home_base"]))
        }
    }
    
    func initGridPoints(data: JSON) {
        grid_nodes.removeAll()
        for gp in data.array! {
            grid_nodes.append(GridPointInfo(tile: Vector2(gp["tile"][0].float!, gp["tile"][1].float!), visit_wait: gp["hack_s"].int!, surge_wait: gp["surge_s"].int!))
        }
    }
    
    func hackGridPoint(tile: Vector2, remaining: Int) {
        if let gp = grid_nodes.first(where: { $0.tile == tile }) {
            gp.hack_wait = Utils.timestamp() + IntMax(remaining)
        } else {
            grid_nodes.append(GridPointInfo(tile: tile, visit_wait: remaining, surge_wait: 0))
        }
    }
    
    func surgeGridPoint(tile: Vector2, remaining: Int) {
        if let gp = grid_nodes.first(where: { $0.tile == tile }) {
            gp.surge_wait = Utils.timestamp() + IntMax(remaining)
        } else {
            grid_nodes.append(GridPointInfo(tile: tile, visit_wait: 0, surge_wait: remaining))
        }
    }
    
    func newHomebase(homebase: Homebase) {
        if self.homebase != nil {
            self.homebase.destroy()
        }
        self.homebase = homebase
        Logging.info(data: "New Homebase \(homebase.tile)")
        NotificationCenter.default.addObserver(self.homebase, selector: #selector(self.homebase.handleHomebaseCheck), name: NSNotification.Name(rawValue: "check-tile-homebase"), object: nil)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "new-homebase"), object: self.homebase)
    }
    
    deinit {
        Logging.info(data: "Player deinit")
    }
}
