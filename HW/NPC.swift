//
//  NPC.swift
//  HW
//
//  Created by Adrian Nenu on 04/04/2017.
//  Copyright © 2017 Adrian Nenu. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import SceneKit

class OccupyInfo {
    let apps: [App]
    let user: String
    
    init(apps: [App], user: String) {
        self.apps = apps
        self.user = user
    }
    
    convenience init(data: JSON) {
        self.init(apps: data["apps"].array!.map({ return App(data: $0) }), user: data["user_id"].string!)
    }
}

class NPC {
    let name: String
    let id: String
    let type: Int
    let coords: Vector2
    let tile: Vector2
    let relativePosition: Vector2
    var node: NPCNode!
    var occupy: OccupyInfo!
    
    init(data: JSON, tileNode: SCNNode) {
        coords = Vector2(x: data["coords"][0].float!, y: data["coords"][1].float!)
        tile = Vector2(x: data["tile"][0].float!, y: data["tile"][1].float!)
        relativePosition =  ((Utils.distanceInMetersBetween(latLon1: Utils.tileToLatLon(tile: self.tile), latLon2: self.coords)) - Vector2(611, 611) / 2)  * Vector2(1, -1)
        
        Logging.info(data: "NPC \(relativePosition) \(self.tile)")
        id = data["_id"].string!
        name = data["name"].string!
        type = data["type"].int!
        
        node = NPCNode(relativePosition: relativePosition, npc: self)
        tileNode.addChildNode(node)
        update(data: data)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "npc-\(self.id)"), object: self)
    }
 
    
    func update(data: JSON) {
        if !data["occupy"].isEmpty {
            self.occupy = OccupyInfo(data: data["occupy"])
            self.node.set(occupied: true)
        } else {
            self.occupy = nil
            self.node.set(occupied: false)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
