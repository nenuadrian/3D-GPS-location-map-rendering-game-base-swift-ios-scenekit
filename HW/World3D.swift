//
//  ViewController.swift
//  HW
//
//  Created by Adrian Nenu on 27/03/2017.
//  Copyright © 2017 Adrian Nenu. All rights reserved.
//

import UIKit
import SwiftHTTP
import SwiftyJSON
import QuartzCore
import CoreMotion
import SceneKit

// TODO when too far send to auth
class World3D: UIViewController {
    static var mapTiles = [Vector2: MapTile]()
    
    private var primordialTile: Vector2!
    private var playerNode: SCNNode!
    private var locationMaster: LocationMaster!
    private var locationTimer: Timer!
    private var npcTimer: Timer!
    private var cameraOrbit: SCNNode!

    var sceneView: SCNView!

    override func viewDidLoad() {
        super.viewDidLoad()
        sceneSetup()

        locationMaster = LocationMaster()
        locationTimer = Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(self.computeTiles), userInfo: nil, repeats: true)
        npcTimer = Timer.scheduledTimer(timeInterval: TimeInterval(5), target: self, selector: #selector(self.npcsStatus), userInfo: nil, repeats: true)
    }
    
    func sceneSetup() {
        sceneView = MapScene(frame: view.frame)
        view.addSubview(sceneView)

        playerNode = PlayerNode()
        sceneView.scene!.rootNode.addChildNode(self.playerNode)

        cameraOrbit = CameraNode(playerNode: self.playerNode, sceneView: sceneView)
    }
    
    func npcsStatus(timer: Timer) {
        API.get(endpoint: "npcs") { (data) in
            data["data"]["npcs"].array!.forEach({ (npc) in
                let tile = Vector2(npc["tile"][0].float!, npc["tile"][1].float!)
                if let myTile = World3D.mapTiles[tile] {
                    let id = npc["_id"].string!
                    if let myNPC = myTile.npcs.first(where: {  $0.id == id }) {
                        myNPC.update(data: npc)
                    } else {
                        myTile.newNPC(data: npc)
                    }
                }
            })
        }
    }
    
    func computeTiles(timer: Timer) {
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
        
        // Logging.info(data: "Player @ P\(playerPosition) OIT\(playerOffsetInsideTile)")
    }
    
    func shutdown() {
        locationTimer?.invalidate()
        npcTimer?.invalidate()
    }
    
    deinit {
        World3D.mapTiles.removeAll()
        Logging.info(data: "Deinit World Controller")
    }
}

