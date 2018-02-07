//
//  AuthViewController.swift
//  HW
//
//  Created by Adrian Nenu on 04/04/2017.
//  Copyright © 2017 Adrian Nenu. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import SwiftHTTP
import QuartzCore
import CoreMotion
import SceneKit

class World3D: UIViewController {
    static var mapTiles = [Vector2: MapTile]()
    
    private var primordialTile: Vector2!
    private var playerNode: SCNNode!
    private var locationMaster: LocationMaster!
    private var locationTimer: Timer!
    private var cameraOrbit: SCNNode!
    
    @objc var sceneView: SCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sceneSetup()
        
        locationMaster = LocationMaster()
        locationTimer = Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(self.computeTiles), userInfo: nil, repeats: true)
    }
    
    @objc func sceneSetup() {
        sceneView = MapScene(frame: view.frame)
        view.addSubview(sceneView)
        
        playerNode = PlayerNode()
        sceneView.scene!.rootNode.addChildNode(self.playerNode)
        
        cameraOrbit = CameraNode(playerNode: self.playerNode, sceneView: sceneView)
    }
    
    @objc func computeTiles(timer: Timer) {
        let playerLatLon = LocationMaster.getLast()
        let currentTile = Utils.latLonToTile(coord: playerLatLon)
        
        if primordialTile == nil {
            primordialTile = currentTile
        }
        
        for i in -Constants.TILE_RANGE...Constants.TILE_RANGE {
            for j in -Constants.TILE_RANGE...Constants.TILE_RANGE {
                let tileKey = currentTile + Vector2(Float(i), Float(j))
                if World3D.mapTiles[tileKey] == nil {
                    World3D.mapTiles[tileKey] = MapTile(tileKey: tileKey, mapNode: sceneView.scene!.rootNode, primordialTile: primordialTile)
                }
            }
        }
        
        let playerOffsetInsideTile = Utils.distanceInMetersBetween(latLon1: Utils.tileToLatLon(tile: currentTile), latLon2: playerLatLon) - Vector2(611, 611)/2
        let playerPosition = World3D.mapTiles[currentTile]!.position + playerOffsetInsideTile * Vector2(1, -1)
        self.playerNode.position = SCNVector3(x: playerPosition.x, y: playerPosition.y, z: 16)
        
         Logging.info(data: "Player @ P\(playerPosition) OIT\(playerOffsetInsideTile)")
    }
    
  
}
