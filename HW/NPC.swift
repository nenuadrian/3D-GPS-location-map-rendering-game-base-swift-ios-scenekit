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

class NPC: UIView, UIGestureRecognizerDelegate {
    var name: String!
    var id: String!
    var type: Int!
    //var data: JSON = JSON.null
    var coords: Vector2 = Vector2.zero
    var tile: Vector2 = Vector2.zero
    var relativePosition: Vector2 = Vector2.zero
    var gridPoint: GridPoint!
    
    init(data: JSON) {
        self.coords = Vector2(x: data["coords"][0].float!, y: data["coords"][1].float!)
        self.tile = Vector2(x: data["tile"][0].float!, y: data["tile"][1].float!)
        self.relativePosition = Utils.latLonToMeters(coord: self.coords) - Utils.latLonToMeters(coord: Utils.tileToLatLon(tile: self.tile))
        self.relativePosition = Vector2(x: abs(self.relativePosition.x), y: abs(self.relativePosition.y))
        
        name = data["name"].string!
        id = data["_id"].string!
        type = data["type"].int!

        super.init(frame: CGRect(x: Double(self.relativePosition.x), y: Double(self.relativePosition.y), width: 10, height: 10))
        backgroundColor = type == 1 ? UIColor.black : UIColor.brown
        
        let tapGesture = UITapGestureRecognizer(target: self, action: nil)
        tapGesture.delegate = self
        addGestureRecognizer(tapGesture)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        GUIMaster.npc(npc: self)
        return false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
