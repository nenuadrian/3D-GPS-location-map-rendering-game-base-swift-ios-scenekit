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
        
        let name = Label(text: "GRID POINT", frame: CGRect(x: 0, y: 20, width: CardinalInterface.subviewWidth, height: 30))
        name.textAlignment = .center
        name.font = name.font.withSize(20)
        addSubview(v: name)
        
        if gridPoint.state == 2 {
            let surgeButton = Btn(title: "surge", position: CGPoint(x: 50, y: 200))
            surgeButton.addTarget(self, action: #selector(self.surgeCall), for: .touchDown)
            addSubview(v: surgeButton)
            surgeButton.centerInParent()
        }
        
        if gridPoint.state == 1 {
            let hackButton = Btn(title: "hack", position: CGPoint(x: 150, y: 200))
            hackButton.addTarget(self, action: #selector(self.hackCall), for: .touchDown)
            addSubview(v: hackButton)
            hackButton.centerInParent()
        }
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
                        Cardinal.player.surgeGridPoint(tile: self.gridPoint.tileKey, remaining: data["data"]["s"].int!)
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
                Cardinal.player.hackGridPoint(tile: self.gridPoint.tileKey, remaining: data["data"]["s"].int!)
            }
        })

    }
}
