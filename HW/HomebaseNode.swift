//
//  PlayerNode.swift
//  HW
//
//  Created by Adrian Nenu on 08/04/2017.
//  Copyright © 2017 Adrian Nenu. All rights reserved.
//

import Foundation
import SceneKit


class HomebaseNode: SCNNode {
    
    init(relativePosition: Vector2) {
        super.init()
        
        let obj =  SCNBox(width: 20, height: 20, length: 20, chamferRadius: 3)

        obj.firstMaterial!.diffuse.contents = UIColor.purple
        obj.firstMaterial!.specular.contents = UIColor.purple
        geometry = obj
        name = "HB"
        position = SCNVector3(relativePosition.x, relativePosition.y, 55)
        
        pivot = SCNMatrix4MakeRotation(Float.pi / 2, 1, 0, 0)
        let spin = CABasicAnimation(keyPath: "rotation")
        // Use from-to to explicitly make a full rotation around z
        spin.fromValue = NSValue(scnVector4: SCNVector4(x: 0, y: 0, z: 1, w: 0))
        spin.toValue = NSValue(scnVector4: SCNVector4(x: 1, y: 1, z: 1, w: Float(CGFloat(2 * Float.pi))))
        spin.duration = 25
        spin.repeatCount = .infinity
        addAnimation(spin, forKey: "spin around")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
