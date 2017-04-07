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

class Homebase {
    let tile: Vector2
    let coords: Vector2
    let relativePosition: Vector2
    var level: Int = 1
    var node: SCNNode!
    
    init(coords: Vector2, level: Int = 1) {
        self.coords = coords
        self.level = level
        tile = Utils.latLonToTile(coord: coords)
        relativePosition =  ((Utils.distanceInMetersBetween(latLon1: Utils.tileToLatLon(tile: self.tile), latLon2: self.coords)) - Vector2(611, 611) / 2)  * Vector2(1, -1)
    }
    
    convenience init(data: JSON) {
        self.init(coords: Vector2(x: data["x"].float!, y: data["y"].float!), level: data["level"].int!)
    }
    
    @objc func handleHomebaseCheck(note: NSNotification) {
        let mapTile = note.object as! MapTile
        placeHomebaseIfOn(mapTile: mapTile)
    }
    
    func placeHomebaseIfOn(mapTile: MapTile) {
        if tile == mapTile.tileKey {
            let obj = SCNSphere(radius: 8.20)
            obj.firstMaterial!.diffuse.contents = UIColor.black
            obj.firstMaterial!.specular.contents = UIColor.black
            node = SCNNode(geometry: obj)
            node.name = "HB"
            node.position = SCNVector3(relativePosition.x, relativePosition.y, 0)
            mapTile.node.addChildNode(node)
        }
    }
    
    func destroy() {
        if node != nil {
            node.removeFromParentNode()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

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

class Player {
    var level: Int = 1
    var exp: Int = 0
    var group: Int = 0
    var username: String = ""
    private var homebase: Homebase!
    var grid_nodes: [GridPointInfo] = []
    
    init(data: JSON) {
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
    
}
