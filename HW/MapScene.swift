//
//  MapScene.swift
//  HW
//
//  Created by Adrian Nenu on 08/04/2017.
//  Copyright © 2017 Adrian Nenu. All rights reserved.
//

import Foundation
import SceneKit

class MapScene: SCNView {
     override init(frame: CGRect) {
        super.init(frame: frame, options: nil)
        let mapScene = SCNScene()
        mapScene.background.contents = UIColor(red:0.82, green:0.82, blue:0.82, alpha:1.0)
        mapScene.fogStartDistance = 900
        mapScene.fogEndDistance = 1100
        mapScene.fogColor = UIColor.black
        
        scene = mapScene
        autoenablesDefaultLighting = true
        /*
        let light = SCNLight()
        let lightNode = SCNNode ()
        light.type = SCNLight.LightType.omni
        light.color = UIColor.blue
        lightNode.light = light
        lightNode.position = SCNVector3 (0, 0, 500)
        scene?.rootNode.addChildNode (lightNode)
        
        let ambientLight = SCNLight ();
        let ambientLightNode = SCNNode ();
        ambientLight.type = SCNLight.LightType.ambient;
        ambientLight.color = UIColor.purple;
        ambientLightNode.light = ambientLight;
        scene?.rootNode.addChildNode (ambientLightNode);
        */
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        addGestureRecognizer(tapGesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        
        let p = gestureRecognize.location(in: self)
        let hitResults = hitTest(p, options: [:])
        
        if let result = hitResults.first {
            if result.node.parentOf(type: PlayerNode.self) != nil {
                PlayerInterface().show()
            } else if result.node.parentOf(type: HomebaseNode.self) != nil {
                HomebaseInterface().show()
            } else if let npc = result.node.parentOf(type: NPCNode.self) {
                let _ = NPCInterface(npc: npc.npc)
            } else if let gp = result.node.parentOf(type: GridPointNode.self) {
                GridPointInterface.init().show(gridPoint: gp.gridPoint)
            }
        }
    }
}
