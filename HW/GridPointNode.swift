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
        name = "GP"
        position = SCNVector3(relativePosition.x, relativePosition.y, 55)

        let obj = SCNPyramid(width: 20, height: 25, length: 20)
        obj.firstMaterial!.diffuse.contents = UIColor.green
        obj.firstMaterial!.specular.contents = UIColor.green
        let nodePart1 = SCNNode(geometry: obj)
        addChildNode(nodePart1)
        nodePart1.eulerAngles = SCNVector3Make(Float.pi/2, 0, 0)

        
        let obj2 = SCNPyramid(width: 20, height: 25, length: 20)
        obj2.firstMaterial!.diffuse.contents = UIColor.green
        obj2.firstMaterial!.specular.contents = UIColor.green
        let nodePart2 = SCNNode(geometry: obj2)
        nodePart2.eulerAngles = SCNVector3Make(-Float.pi/2, 0, 0)
        addChildNode(nodePart2)
        
        let spin = CABasicAnimation(keyPath: "eulerAngles")
        // Use from-to to explicitly make a full rotation around z
        spin.fromValue = NSValue(scnVector3: SCNVector3(x: 0, y: 0, z: 0))
        spin.toValue = NSValue(scnVector3: SCNVector3(x: 0, y: 0, z: Float.pi))
        spin.duration = 5
        spin.repeatCount = .infinity
        addAnimation(spin, forKey: "spin around")
    }
    
    func set(color: UIColor) {
        childNodes.forEach {
            $0.geometry!.firstMaterial!.specular.contents = color
            $0.geometry!.firstMaterial!.diffuse.contents = color
        }
    }
    
    func set(state: Int) {
        switch state {
        case 2:
            set(color: UIColor.brown)
            break
        case 1:
            set(color: UIColor.green)
            break
        case 3:
            set(color: UIColor.red)
            break
        default: break
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
