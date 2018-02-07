//
//  PlayerNode.swift
//  HW
//
//  Created by Adrian Nenu on 08/04/2017.
//  Copyright © 2017 Adrian Nenu. All rights reserved.
//

import Foundation
import SceneKit


class PlayerNode: SCNNode {
    override init() {
        super.init()
        name = "P"
        let obj = SCNSphere(radius: 3)
        obj.firstMaterial!.diffuse.contents = UIColor.white
        obj.firstMaterial!.specular.contents = UIColor.black
        geometry = obj
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
