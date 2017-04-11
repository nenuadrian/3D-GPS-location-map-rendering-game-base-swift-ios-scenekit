//
//  PlayerNode.swift
//  HW
//
//  Created by Adrian Nenu on 08/04/2017.
//  Copyright © 2017 Adrian Nenu. All rights reserved.
//

import Foundation
import SceneKit


class NPCNode: SCNNode {
    let npc: NPC
    init(relativePosition: Vector2, npc: NPC) {
        self.npc = npc
        super.init()
        
        let obj = SCNPlane.init(width: 20, height: 50)
        obj.firstMaterial!.diffuse.contents = UIImage(named: "etta_medium")
        obj.firstMaterial!.isDoubleSided = true
        
        let node = SCNNode(geometry: obj)
        node.eulerAngles = SCNVector3Make(-Float.pi/2, 0, Float.pi/2)
        
        addChildNode(node)
        
        name = "NPC"
        position = SCNVector3(relativePosition.x, relativePosition.y, 20)


        let spin = CABasicAnimation(keyPath: "eulerAngles")
        // Use from-to to explicitly make a full rotation around z
        spin.fromValue = NSValue(scnVector3: SCNVector3(x: 0, y: 0, z: 0))
        spin.toValue = NSValue(scnVector3: SCNVector3(x: 0, y: 0, z: Float.pi))
        spin.duration = 5
        spin.repeatCount = .infinity
        addAnimation(spin, forKey: "spin around")
    }
    
    func set(occupied: Bool) {
        if occupied {
           // geometry!.firstMaterial?.diffuse.contents = UIColor.white
            //geometry!.firstMaterial?.diffuse.contents = UIColor.white
        } else {
            //geometry!.firstMaterial!.diffuse.contents = UIColor.yellow
            //geometry!.firstMaterial!.specular.contents = UIColor.yellow
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
