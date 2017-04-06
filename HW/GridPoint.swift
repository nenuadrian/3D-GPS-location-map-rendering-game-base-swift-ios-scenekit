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
        obj.firstMaterial!.diffuse.contents = UIColor.purple
        obj.firstMaterial!.specular.contents = UIColor.purple
        node.geometry = obj
        
        
        self.setState(state: 1)
       
    }
    
    public func setState(state: Int, remaining: Int = 0) {
        self.state = state
        DispatchQueue.main.async {
            if self.timer != nil {
                self.timer.invalidate()
            }
            switch self.state {
            case 2:
                Timer.scheduledTimer(timeInterval: TimeInterval(remaining), target: self, selector: #selector(self.resetState), userInfo: nil, repeats: false)
                break
            case 1:
                break
            case 3:
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
