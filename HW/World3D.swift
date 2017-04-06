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
    static var tilesDataCache = [Vector2: JSON]()
    
    static var primordialTile: Vector2!
    static var playerNode: SCNNode!
    var locationMaster: LocationMaster!
    
    var sceneView: SCNView!
    var mapScene: SCNScene!
    var cameraOrbit: SCNNode!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sceneSetup()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView = SCNView(frame: view.frame)
        view.addSubview(sceneView)
        sceneSetup()

        locationMaster = LocationMaster()
        Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(self.computeTiles), userInfo: nil, repeats: true)
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        sceneView.addGestureRecognizer(tapGesture)
    }
    
    func cameraSetup() {
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        sceneView.addGestureRecognizer(gestureRecognizer)
        
        let camera = SCNCamera()
        camera.zNear = 1
        camera.zFar = 10000
        let cameraNode = SCNNode()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 300)
        cameraNode.camera = camera
        cameraOrbit = SCNNode()
        cameraOrbit.addChildNode(cameraNode)
        self.cameraOrbit.eulerAngles.x = 1.06447
        World3D.playerNode.addChildNode(cameraOrbit)
        let constraint = SCNLookAtConstraint(target: World3D.playerNode)
        cameraNode.constraints = [constraint]
    }
    
    func sceneSetup() {
        mapScene = SCNScene()
        mapScene.background.contents = UIColor(red:0.82, green:0.82, blue:0.82, alpha:1.0)
        sceneView.scene = mapScene
        sceneView.autoenablesDefaultLighting = true

        let player = SCNSphere(radius: 5.20)
        player.firstMaterial!.diffuse.contents = UIColor.red
        player.firstMaterial!.specular.contents = UIColor.white
        World3D.playerNode = SCNNode(geometry: player)
        World3D.playerNode.name = "P"
        mapScene.rootNode.addChildNode(World3D.playerNode)
        
        cameraSetup()
    }
    
    func npcsStatus(timer: Timer) {
        API.get(endpoint: "npcs") { (data) in
            data["data"]["npcs"].array!.forEach({ (npc) in
                let id = npc["_id"].string!
                let tile = Vector2(npc["tile"][0].float!, npc["tile"][1].float!)
                if let myTile = World3D.mapTiles[tile] {
                    if let myNPC = myTile.npcs.first(where: {  $0.id == id }) {
                        myNPC.update(data: npc)
                    }
                }
            })
        }
    }
    
    func computeTiles(timer: Timer) {
        let playerLatLon = LocationMaster.getLast()
        let currentTile = Utils.latLonToTile(coord: playerLatLon)

        if World3D.primordialTile == nil {
            World3D.primordialTile = currentTile
        }
        
        for i in -Constants.TILE_RANGE...Constants.TILE_RANGE {
            for j in -Constants.TILE_RANGE...Constants.TILE_RANGE {
                let tileKey = currentTile + Vector2(Float(i), Float(j))
                if World3D.mapTiles[tileKey] == nil {
                    World3D.mapTiles[tileKey] = MapTile(tileKey: tileKey, mapNode: mapScene.rootNode)
                }
            }
        }
        
        
        let playerOffsetInsideTile = Utils.distanceInMetersBetween(latLon1: Utils.tileToLatLon(tile: currentTile), latLon2: playerLatLon) - Vector2(611, 611)/2
        let playerPosition = World3D.mapTiles[currentTile]!.position + playerOffsetInsideTile * Vector2(1, -1)
        World3D.playerNode.position = SCNVector3(x: playerPosition.x, y: playerPosition.y, z: 10)
        
        Logging.info(data: "Player @ P\(playerPosition) OIT\(playerOffsetInsideTile)")
    }
    
    var lastWidthRatio: Float = 0
    var lastHeightRatio: Float = 1.06447 / Float.pi

    func handlePanGesture(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: sender.view!)
        
        let widthRatio = Float(translation.x) / Float(360) + lastWidthRatio
        let heightRatio = Float(translation.y) / Float(sender.view!.frame.size.height) + lastHeightRatio
        
        self.cameraOrbit.eulerAngles.z = -Float.pi*2 * widthRatio
        self.cameraOrbit.eulerAngles.x = max(0.412028, min(1.40134, Float.pi * heightRatio))

        if (sender.state == .ended) {
            lastWidthRatio = widthRatio.remainder(dividingBy: 1)
            lastHeightRatio = heightRatio.remainder(dividingBy: 1)
        }
    }
  
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        
        let p = gestureRecognize.location(in: sceneView)
        let hitResults = sceneView.hitTest(p, options: [:])

        if let result = hitResults.first {
            if let name = result.node.name {
                switch name {
                    case "NPC":
                        for t in World3D.mapTiles {
                            for n in t.value.npcs {
                                if n.node == result.node {
                                    print("FOUND NPC")
                                    GUIMaster.npc(npc: n)

                                }
                            }
                        }
                        break;
                case "GP":
                    for t in World3D.mapTiles {
                        if result.node == t.value.gridPoint.node {
                            print("FOUND GP")
                            GridPointInterface.init().show(gridPoint: t.value.gridPoint)
                        }
                    }
                    break;
                case "HB":
                   GUIMaster.homebase()
                    break;
                case "P":
                    API.put(endpoint: "tasks/homebase", callback: { (data) in
                        if data["code"].int! == 200 {
                        }
                    })
                    break;
                default:
                    break;
                }
            }
        }
    }
}

