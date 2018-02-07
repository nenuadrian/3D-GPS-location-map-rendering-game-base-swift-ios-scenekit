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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
}
