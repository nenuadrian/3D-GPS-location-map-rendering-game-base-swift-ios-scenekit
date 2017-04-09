//
//  Homebase.swift
//  HackerC
//
//  Created by Adrian Nenu on 09/04/2017.
//  Copyright © 2017 Adrian Nenu. All rights reserved.
//

import Foundation
import SceneKit
import SwiftyJSON

class Homebase {
    let tile: Vector2
    let coords: Vector2
    let relativePosition: Vector2
    var level: Int = 1
    var node: HomebaseNode!
    
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
            node = HomebaseNode(relativePosition: relativePosition)
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
