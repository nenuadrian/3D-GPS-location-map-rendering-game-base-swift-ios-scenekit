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

class NPC {
    let name: String
    let id: String
    let type: Int
    let coords: Vector2
    let tile: Vector2
    let relativePosition: Vector2
    
    init(data: JSON) {
        self.coords = Vector2(x: data["coords"][0].float!, y: data["coords"][1].float!)
        self.tile = Vector2(x: data["tile"][0].float!, y: data["tile"][1].float!)
        let relativePosition2 = Utils.latLonToMeters(coord: self.coords) - Utils.latLonToMeters(coord: Utils.tileToLatLon(tile: self.tile))
        relativePosition = Vector2(x: abs(relativePosition2.x), y: abs(relativePosition2.y))
        
        id = data["_id"].string!
        name = data["name"].string!
        type = data["type"].int!
    }
    
    func update(data: JSON) {
        
    }
}

class NPCView: UIView, UIGestureRecognizerDelegate {
    let npc: NPC
    init(npc: NPC) {
        self.npc = npc

        super.init(frame: CGRect(x: Double(npc.relativePosition.x), y: Double(npc.relativePosition.y), width: 10, height: 10))

        backgroundColor = npc.type == 1 ? UIColor.black : UIColor.brown
        
        let tapGesture = UITapGestureRecognizer(target: self, action: nil)
        tapGesture.delegate = self
        addGestureRecognizer(tapGesture)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        GUIMaster.npc(npc: npc)
        return false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
