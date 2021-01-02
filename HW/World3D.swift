//
//  AuthViewController.swift
//  HW
//
//  Created by Adrian Nenu on 04/04/2017.
//  Copyright © 2017 Adrian Nenu. All rights reserved.
//

import Foundation
import UIKit

import QuartzCore
import CoreMotion
import SceneKit

class World3D: UIViewController {
    static var mapTiles = [String: MapTile]()
    
    private var primordialTile: (Int, Int)!
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
                let tileKey = (currentTile.0 + i, currentTile.1 + j)
                if World3D.mapTiles["\(tileKey.0)\(tileKey.1)"] == nil {
                    World3D.mapTiles["\(tileKey.0)\(tileKey.1)"] =
                        MapTile(tileKey: tileKey, mapNode: sceneView.scene!.rootNode, primordialTile: primordialTile)
                }
            }
        }
        
        let playerOffset = Utils.distanceInMetersBetween(latLon1: Utils.tileToLatLon(tile: currentTile), latLon2: playerLatLon)
        let playerOffsetInsideTile = (playerOffset.0 - 611/2, playerOffset.1 - 611/2)
        let playerPosition = (Double(World3D.mapTiles["\(currentTile.0)\(currentTile.1)"]!.position.0) + playerOffsetInsideTile.0,
                              (Double(World3D.mapTiles["\(currentTile.0)\(currentTile.1)"]!.position.1) + playerOffsetInsideTile.1) * -1)
        self.playerNode.position = SCNVector3(x: Float(playerPosition.0), y: Float(playerPosition.1), z: 16)
        
         Logging.info(data: "Player @ P\(playerPosition) OIT\(playerOffsetInsideTile)")
    }
    
  
}
