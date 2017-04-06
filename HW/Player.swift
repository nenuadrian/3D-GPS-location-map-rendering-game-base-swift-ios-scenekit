//
//  Player.swift
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
    var coords: Vector2
    var relativePosition: Vector2
    var level: Int = 1
    var node: SCNNode!
    
    init(coords: Vector2, level: Int = 1) {
        if Player.homebase != nil {
            Player.homebase.node.removeFromParentNode()
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
        if Player.homebase != nil && Player.homebase.tile == mapTile.tileKey {
            let obj = SCNSphere(radius: 8.20)
            obj.firstMaterial!.diffuse.contents = UIColor.black
            obj.firstMaterial!.specular.contents = UIColor.black
            Player.homebase.node = SCNNode(geometry: obj)
            Player.homebase.node.name = "HB"
            Player.homebase.node.position = SCNVector3(Player.homebase.relativePosition.x, Player.homebase.relativePosition.y, 0)
            mapTile.node.addChildNode(Player.homebase.node)
        }
    }
}

class Player {
    static var level: Int = 1
    static var exp: Int = 0
    static var group: Int = 0
    static var username: String = ""
    static var homebase: Homebase!
    
    static func initPlayer(data: JSON) {
        Player.level = data["level"].int!
        Player.exp = data["exp"].int!
        Player.group = data["group"].int!
        Player.username = data["username"].string!
    }
}
