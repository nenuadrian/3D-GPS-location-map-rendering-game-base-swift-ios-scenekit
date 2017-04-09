//
//  PlayerNode.swift
//  HW
//
//  Created by Adrian Nenu on 08/04/2017.
//  Copyright © 2017 Adrian Nenu. All rights reserved.
//

import Foundation
import SceneKit


class GridPointNode: SCNNode {
    let gridPoint: GridPoint
    init(relativePosition: Vector2, gridPoint: GridPoint) {
        self.gridPoint = gridPoint
        super.init()
        
        let obj = SCNPyramid(width: 20, height: 30, length: 20)
        obj.firstMaterial!.diffuse.contents = UIColor.green
        obj.firstMaterial!.specular.contents = UIColor.green
        geometry = obj
        name = "GP"
        position = SCNVector3(relativePosition.x, relativePosition.y, 55)
        pivot = SCNMatrix4MakeRotation(Float.pi / 2, 1, 0, 0)
        let spin = CABasicAnimation(keyPath: "rotation")
        // Use from-to to explicitly make a full rotation around z
        spin.fromValue = NSValue(scnVector4: SCNVector4(x: 0, y: 0, z: 1, w: 0))
        spin.toValue = NSValue(scnVector4: SCNVector4(x: 0, y: 0, z: 1, w: Float(CGFloat(2 * Float.pi))))
        spin.duration = 5
        spin.repeatCount = .infinity
        addAnimation(spin, forKey: "spin around")
    }
    
    func set(state: Int) {
        switch state {
        case 2:
            self.geometry!.firstMaterial!.specular.contents = UIColor.brown
            self.geometry!.firstMaterial!.diffuse.contents = UIColor.brown
            break
        case 1:
            self.geometry!.firstMaterial!.diffuse.contents = UIColor.green
            self.geometry!.firstMaterial!.specular.contents = UIColor.green
            
            break
        case 3:
            self.geometry!.firstMaterial!.specular.contents = UIColor.red
            self.geometry!.firstMaterial!.diffuse.contents = UIColor.red
            break
        default: break
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
