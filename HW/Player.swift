//
//  Player.current.swift
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
        if Player.current.homebase != nil && Player.current.homebase.node != nil {
            Player.current.homebase.node.removeFromParentNode()
        }
        
        self.coords = coords
        self.level = level
        tile = Utils.latLonToTile(coord: coords)
        relativePosition =  ((Utils.distanceInMetersBetween(latLon1: Utils.tileToLatLon(tile: self.tile), latLon2: self.coords)) - Vector2(611, 611) / 2)  * Vector2(1, -1)

        World3D.mapTiles.forEach( { Homebase.placeIfOn(mapTile: $0.value) } )
    }
    
    convenience init(data: JSON) {
        self.init(coords: Vector2(x: data["x"].float!, y: data["y"].float!), level: data["level"].int!)

    }
    
    static func placeIfOn(mapTile: MapTile) {
        if Player.current.homebase != nil && Player.current.homebase.tile == mapTile.tileKey {
            let obj = SCNSphere(radius: 8.20)
            obj.firstMaterial!.diffuse.contents = UIColor.black
            obj.firstMaterial!.specular.contents = UIColor.black
            Player.current.homebase.node = SCNNode(geometry: obj)
            Player.current.homebase.node.name = "HB"
            Player.current.homebase.node.position = SCNVector3(Player.current.homebase.relativePosition.x, Player.current.homebase.relativePosition.y, 0)
            mapTile.node.addChildNode(Player.current.homebase.node)
        }
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
    static var current: Player!
    var level: Int = 1
    var exp: Int = 0
    var group: Int = 0
    var username: String = ""
    var homebase: Homebase!
    var grid_nodes: [GridPointInfo] = []
    
    init(data: JSON) {
        Player.current = self
        level = data["level"].int!
        exp = data["exp"].int!
        group = data["group"].int!
        username = data["username"].string!
    }
    
    static func initGridPoints(data: JSON) {
        Player.current.grid_nodes.removeAll()
        for gp in data.array! {
            Player.current.grid_nodes.append(GridPointInfo(tile: Vector2(gp["tile"][0].float!, gp["tile"][1].float!), visit_wait: gp["hack_s"].int!, surge_wait: gp["surge_s"].int!))
        }
    }
    
    static func hackGridPoint(tile: Vector2, remaining: Int) {
        if let gp = Player.current.grid_nodes.first(where: { $0.tile == tile }) {
            gp.hack_wait = Utils.timestamp() + IntMax(remaining)
        } else {
            Player.current.grid_nodes.append(GridPointInfo(tile: tile, visit_wait: remaining, surge_wait: 0))
        }
    }
    
    static func surgeGridPoint(tile: Vector2, remaining: Int) {
        if let gp = Player.current.grid_nodes.first(where: { $0.tile == tile }) {
            gp.surge_wait = Utils.timestamp() + IntMax(remaining)
        } else {
            Player.current.grid_nodes.append(GridPointInfo(tile: tile, visit_wait: 0, surge_wait: remaining))
        }
    }
}
