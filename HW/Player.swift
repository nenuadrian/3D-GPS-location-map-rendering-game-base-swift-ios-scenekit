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

class Homebase {
    var tile: Vector2!
    var coords: Vector2!
    var relativeCoords: Vector2!
    var level: Int = 1
    var view: HomebaseView!
    
    init(coords: Vector2, level: Int = 1) {
        if Player.homebase != nil {
            Player.homebase.view.removeFromSuperview()
        }
        
        self.coords = coords
        self.level = level
        self.tile = Utils.latLonToTile(coord: coords)
        self.relativeCoords = Utils.latLonToMeters(coord: coords) - Utils.latLonToMeters(coord: Utils.tileToLatLon(tile: self.tile))
        self.relativeCoords = Vector2(x: abs(self.relativeCoords.x), y: abs(self.relativeCoords.y))
       // WorldViewController.mapTiles.forEach( { Homebase.placeIfOn(mapTile: $0.value) } )
    }
    
    convenience init(data: JSON) {
        self.init(coords: Vector2(x: data["x"].float!, y: data["y"].float!), level: data["level"].int!)

    }
    
    /*static func placeIfOn(mapTile: Tile2D) {
        if Player.homebase != nil && Player.homebase.tile! == mapTile.tileKey {
            Player.homebase.view =
                HomebaseView(frame: CGRect(x: Double(Player.homebase.relativeCoords.x), y: Double(Player.homebase.relativeCoords.y), width: 30, height: 30))
            mapTile.addSubview(Player.homebase.view)
        }
    }*/
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

    /*func someAction(_ sender:UITapGestureRecognizer) {
        API.put(endpoint: "tasks/homebase", callback: { (data) in
            if data["code"].int! == 200 {
            }
        })
    }*/
    
}
