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

class World3DViewController: UIViewController {
    static var mapTiles = [Vector2: MapTile]()
    static var tilesDataCache = [Vector2: JSON]()
    
    static var primordialTile: Vector2!
    static var playerNode: SCNNode!
    var locationMaster: LocationMaster!
    
    static var sceneView: SCNView!
    static var mapScene: SCNScene!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sceneSetup()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        World3DViewController.sceneView = SCNView(frame: view.frame)
        World3DViewController.sceneView.allowsCameraControl = true

        view.addSubview(World3DViewController.sceneView)
        sceneSetup()

        locationMaster = LocationMaster()
        Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(self.computeTiles), userInfo: nil, repeats: true)
    }
    
    func sceneSetup() {
        World3DViewController.mapScene = SCNScene()
     
       /* let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLight.LightType.ambient
        ambientLightNode.light!.color = UIColor(white: 0.67, alpha: 1.0)
        World3DViewController.mapScene.rootNode.addChildNode(ambientLightNode)
        
        let omniLightNode = SCNNode()
        omniLightNode.light = SCNLight()
        omniLightNode.light!.type = SCNLight.LightType.omni
        omniLightNode.light!.color = UIColor(white: 0.75, alpha: 1.0)
        omniLightNode.position = SCNVector3Make(0, 50, 50)
        World3DViewController.mapScene.rootNode.addChildNode(omniLightNode)*/
        
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3Make(0, 0, 300)
        cameraNode.camera?.zFar = 100000
        cameraNode.camera?.zNear = 1
        
        World3DViewController.mapScene.rootNode.addChildNode(cameraNode)
        
        let player = SCNSphere(radius: 5.20)
        player.firstMaterial!.diffuse.contents = UIColor.red
        player.firstMaterial!.specular.contents = UIColor.white
        
        World3DViewController.playerNode = SCNNode(geometry: player)
        World3DViewController.mapScene.rootNode.addChildNode(World3DViewController.playerNode)
        
        let lookAt = SCNLookAtConstraint(target: cameraNode)
        World3DViewController.playerNode.constraints = [lookAt]
        
        // 2
       /* let boxGeometry = SCNBox(width: 10.0, height: 10.0, length: 10.0, chamferRadius: 1.0)
        let boxNode = SCNNode(geometry: boxGeometry)
        scene.rootNode.addChildNode(boxNode)*/
        
        let ground = SCNPlane(width: 10000, height: 10000)
        ground.firstMaterial!.diffuse.contents          = UIColor.black
        ground.firstMaterial!.specular.contents          = UIColor.black
        let groundNode = SCNNode(geometry: ground)
        groundNode.position = SCNVector3(x: 0, y: 0, z: 0)

        //scene.rootNode.addChildNode(groundNode)
        
        
        //silverMaterial.diffuse.contents = [UIImage imageNamed:@"art.scnassets/silver-background.png"];

               // 3
        World3DViewController.sceneView.scene = World3DViewController.mapScene
        World3DViewController.sceneView.autoenablesDefaultLighting = true
        
        
        
        
        let origin = SCNSphere(radius: 5.20)
        origin.firstMaterial!.diffuse.contents = UIColor.green
        origin.firstMaterial!.specular.contents = UIColor.green
        let originNode = SCNNode(geometry: origin)
        originNode.position = SCNVector3(0,0, 10)
        World3DViewController.mapScene.rootNode.addChildNode(originNode)

        
        let next = SCNSphere(radius: 5.20)
        next.firstMaterial!.diffuse.contents = UIColor.purple
        next.firstMaterial!.specular.contents = UIColor.purple
        let nextNode = SCNNode(geometry: next)
        nextNode.position = SCNVector3(611,611, 10)
        World3DViewController.mapScene.rootNode.addChildNode(nextNode)

    }
    
   
 
    
    func npcsStatus(timer: Timer) {
        API.get(endpoint: "npcs") { (data) in
            data["data"]["npcs"].array!.forEach({ (npc) in
                let id = npc["_id"].string!
                let tile = Vector2(npc["tile"][0].float!, npc["tile"][1].float!)
                if let myTile = World3DViewController.mapTiles[tile] {
                    if let myNPC = myTile.npcs.first(where: {  $0.npc.id == id }) {
                        myNPC.npc.update(data: npc)
                    }
                }
            })
        }
    }
    
    func computeTiles(timer: Timer) {
        let locMeters = Utils.latLonToMeters(coord: LocationMaster.getLast())
        let currentTile = Utils.latLonToTile(coord: LocationMaster.getLast())
        let currentTileLatLon = Utils.tileToLatLon(tile: currentTile)
        let currentTileMeters = Utils.latLonToMeters(coord: currentTileLatLon)
        var playerOffsetInsideTile = locMeters - currentTileMeters
        playerOffsetInsideTile = Vector2(abs(playerOffsetInsideTile.x), 611 - abs(playerOffsetInsideTile.y))
        if World3DViewController.primordialTile == nil {
            World3DViewController.primordialTile = currentTile
        }
        
       // let primordialLatLon = Utils.tileToLatLon(tile: World3DViewController.primordialTile)
     //   let primordialMeters = Utils.latLonToMeters(coord: primordialLatLon)
        
        //let primordialOffset = primordialMeters - currentTileMeters
        //let prepare = Vector2(Float(mapScrollView.contentSize.width), Float(mapScrollView.contentSize.height)) / 2 - primordialOffset + Vector2(-5000, -5000) - playerOffsetInsideTile
        
        //mapView.frame.origin = CGPoint(x: Double(prepare.x), y: Double(prepare.y))
        
        let playerOffset = (World3DViewController.primordialTile - currentTile) * 611 + playerOffsetInsideTile
        World3DViewController.playerNode.position = SCNVector3(x: playerOffset.x, y: playerOffset.y, z: 10)
        print(World3DViewController.playerNode.position)
        
        for i in -Constants.TILE_RANGE...Constants.TILE_RANGE {
            for j in -Constants.TILE_RANGE...Constants.TILE_RANGE {
                let tileKey = currentTile + Vector2(Float(i), Float(j))
                if World3DViewController.mapTiles[tileKey] == nil {
                    let mapTile = MapTile(tileKey: tileKey)
                    World3DViewController.mapTiles[tileKey] = mapTile
                }
            }
        }
        
    }
}

