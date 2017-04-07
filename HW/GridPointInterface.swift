//
//  GridPointInterface.swift
//  HW
//
//  Created by Adrian Nenu on 05/04/2017.
//  Copyright © 2017 Adrian Nenu. All rights reserved.
//

import Foundation
import UIKit

class GridPointInterface: CardinalInterface {
    var gridPoint: GridPoint!
    
    func show(gridPoint: GridPoint) {
        self.gridPoint = gridPoint
        
        let surgeButton = UIButton(frame: CGRect(x: 50, y: 200, width: 100, height:30))
        surgeButton.setTitle("surgeButton", for: .normal)
        surgeButton.addTarget(self, action: #selector(self.surgeCall), for: .touchDown)
        addSubview(v: surgeButton)
        
        let hackButton = UIButton(frame: CGRect(x: 150, y: 200, width: 100, height:30))
        hackButton.setTitle("hackButton", for: .normal)
        hackButton.addTarget(self, action: #selector(self.hackCall), for: .touchDown)
        addSubview(v: hackButton)
    }
    
    @objc func surgeCall(_ sender: AnyObject?) {
        surge()
        close()
    }
    
    @objc func hackCall(_ sender: AnyObject?) {
        hack()
        close()
    }
    
    func surge() {
        API.post(endpoint: "gridPoint/\(Int(gridPoint.tileKey.x))/\(Int(gridPoint.tileKey.y))/surge", callback: { (data) in
            if data["code"].int! == 200 {
                for tileData in data["data"]["network"].array! {
                    let tile = Vector2(tileData[0].float!, tileData[1].float!)
                    if let mapTile = World3D.mapTiles[tile] {
                        mapTile.gridPoint.setState(state: 3, remaining: data["data"]["s"].int!)
                        Player.surgeGridPoint(tile: self.gridPoint.tileKey, remaining: data["data"]["s"].int!)
                    }
                }
            } else if data["code"].int! == 418 {
                
            }
        })
    }
    
    func hack() {
        API.post(endpoint: "gridPoint/\(Int(gridPoint.tileKey.x))/\(Int(gridPoint.tileKey.y))/hack", callback: { (data) in
            if data["code"].int! == 200 {
                self.gridPoint.setState(state: 2, remaining: data["data"]["s"].int!)
                Player.hackGridPoint(tile: self.gridPoint.tileKey, remaining: data["data"]["s"].int!)
            }
        })

    }
}
