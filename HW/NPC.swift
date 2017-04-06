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

class NPC {
    let name: String
    let id: String
    let type: Int
    let coords: Vector2
    let tile: Vector2
    let relativePosition: Vector2
    let node: SCNNode
    
    init(data: JSON, tileNode: SCNNode) {
        self.coords = Vector2(x: data["coords"][0].float!, y: data["coords"][1].float!)
        self.tile = Vector2(x: data["tile"][0].float!, y: data["tile"][1].float!)
        let relativePosition2 = Utils.latLonToMeters(coord: self.coords) - Utils.latLonToMeters(coord: Utils.tileToLatLon(tile: self.tile))
        relativePosition = Vector2(x: abs(relativePosition2.x), y: 611 - abs(relativePosition2.y)) - Vector2(611, 611) / 2
        print("NPC \(relativePosition) \(self.tile)")
        id = data["_id"].string!
        name = data["name"].string!
        type = data["type"].int!
        
        let obj = SCNSphere(radius: 8.20)
        obj.firstMaterial!.diffuse.contents = UIColor.yellow
        obj.firstMaterial!.specular.contents = UIColor.yellow
        node = SCNNode(geometry: obj)
        node.name = "NPC"
        node.position = SCNVector3(relativePosition.x, relativePosition.y, 0)
        tileNode.addChildNode(node)
        
        render()
    }
    
    func render() {
        let obj = SCNSphere(radius: 8.20)
        obj.firstMaterial!.diffuse.contents = UIColor.yellow
        obj.firstMaterial!.specular.contents = UIColor.yellow
        
        node.geometry = obj
    }
    
    func update(data: JSON) {

    }
}
