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
        
        let obj = SCNBox.init(width: 10, height: 10, length: 30, chamferRadius: 4)
        obj.firstMaterial!.diffuse.contents = UIColor.yellow
        obj.firstMaterial!.specular.contents = UIColor.yellow
        geometry = obj
        name = "NPC"
        position = SCNVector3(relativePosition.x, relativePosition.y, 25)
    }
    
    func set(occupied: Bool) {
        if occupied {
            geometry!.firstMaterial?.diffuse.contents = UIColor.white
            geometry!.firstMaterial?.diffuse.contents = UIColor.white
        } else {
            geometry!.firstMaterial!.diffuse.contents = UIColor.yellow
            geometry!.firstMaterial!.specular.contents = UIColor.yellow
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
