//
//  PlayerNode.swift
//  HW
//
//  Created by Adrian Nenu on 08/04/2017.
//  Copyright © 2017 Adrian Nenu. All rights reserved.
//

import Foundation
import SceneKit


class CameraNode: SCNNode {
    var lastWidthRatio: Float = 0
    var lastHeightRatio: Float = 1.06447 / Float.pi
    
    init(playerNode: SCNNode, sceneView: SCNView) {
        super.init()
        
        let camera = SCNCamera()
        camera.zNear = 1
        camera.zFar = 1200
        let cameraNode = SCNNode()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 200)
        cameraNode.camera = camera
        addChildNode(cameraNode)
        eulerAngles.x = 1.06447
        
        playerNode.addChildNode(self)
        let constraint = SCNLookAtConstraint(target: playerNode)
        cameraNode.constraints = [constraint]
        
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        sceneView.addGestureRecognizer(gestureRecognizer)
    }
    
    func handlePanGesture(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: sender.view!)
        
        let widthRatio = Float(translation.x) / Float(360) + lastWidthRatio
        let heightRatio = Float(translation.y) / Float(sender.view!.frame.size.height) + lastHeightRatio
        
        eulerAngles.z = -Float.pi*2 * widthRatio
        eulerAngles.x = max(0.412028, min(1.40134, Float.pi * heightRatio))
        
        if (sender.state == .ended) {
            lastWidthRatio = widthRatio.remainder(dividingBy: 1)
            lastHeightRatio = heightRatio.remainder(dividingBy: 1)
        }
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
