//
//  GridPoint.swift
//  HW
//
//  Created by Adrian Nenu on 28/03/2017.
//  Copyright © 2017 Adrian Nenu. All rights reserved.
//

import Foundation
import UIKit
import SwiftHTTP
import SceneKit

class GridPoint {
    var tileKey: Vector2 = Vector2.zero
    var gridPointPosition: Vector2!
    var state: Int = 1
    var timer: Timer!
    let node: SCNNode
    
    init(tile: MapTile) {
        self.tileKey = tile.tileKey
        let gridPointPosition = GridPoint.pseudorrandomPosition(of: tileKey)
        
        self.gridPointPosition = Vector2(gridPointPosition.x, 611 - gridPointPosition.y)
        print("GP \(tileKey) \(gridPointPosition)")
        
        node = SCNNode()
        node.name = "GP"
        node.position = SCNVector3(gridPointPosition.x, gridPointPosition.y, 10)
        tile.node.addChildNode(node)

        let obj = SCNSphere(radius: 8.20)
        obj.firstMaterial!.diffuse.contents = UIColor.green
        obj.firstMaterial!.specular.contents = UIColor.green
        node.geometry = obj
        
        
        if let gp = Player.current.grid_nodes.first(where: { $0.tile == tileKey }) {
            if gp.surge_wait > Utils.timestamp() {
                setState(state: 3, remaining: Int(gp.surge_wait - Utils.timestamp()))
            } else if gp.hack_wait > Utils.timestamp() {
                setState(state: 2, remaining: Int(gp.hack_wait - Utils.timestamp()))
            } else {
                self.setState(state: 1)
            }
        } else {
            self.setState(state: 1)
        }
    }
    
    public func setState(state: Int, remaining: Int = 0) {
        self.state = state
        Logging.info(data: "GP state \(state)")

        DispatchQueue.main.async {
            if self.timer != nil {
                self.timer.invalidate()
            }
            switch self.state {
            case 2:
                self.node.geometry!.firstMaterial!.specular.contents = UIColor.brown
                self.node.geometry!.firstMaterial!.diffuse.contents = UIColor.brown
                Timer.scheduledTimer(timeInterval: TimeInterval(remaining), target: self, selector: #selector(self.resetState), userInfo: nil, repeats: false)
                break
            case 1:
                self.node.geometry!.firstMaterial!.diffuse.contents = UIColor.green
                self.node.geometry!.firstMaterial!.specular.contents = UIColor.green

                break
            case 3:
                self.node.geometry!.firstMaterial!.specular.contents = UIColor.red
                self.node.geometry!.firstMaterial!.diffuse.contents = UIColor.red

                Timer.scheduledTimer(timeInterval: TimeInterval(remaining), target: self, selector: #selector(self.resetState), userInfo: nil, repeats: false)
                break
            default: break
            }
        }
        
    }
    
    @objc func resetState(timer: Timer) {
        self.setState(state: 1)
    }
    
    static func pseudorrandomPosition(of: Vector2) -> Vector2 {
        srand48(Int(of.x) * Int(of.y) * Int(10000))
        return Vector2(Float(611) / 2, Float(611) / 2) +
            Vector2(Float(200 - Int((drand48() * 1000).truncatingRemainder(dividingBy: 500))),
                    Float(200 - Int((drand48() * 1000).truncatingRemainder(dividingBy: 500))))
    }
}
