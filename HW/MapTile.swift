//
//  Tile.swift
//  HW
//
//  Created by Adrian Nenu on 27/03/2017.
//  Copyright © 2017 Adrian Nenu. All rights reserved.
//

import Foundation
import UIKit
import SceneKit
import Cache
import SwiftyJSON

class MapTile {
    var data: SwiftyJSON.JSON = JSON.null
    let tileKey: Vector2
    let position: Vector2
    var gridPoint: GridPoint!
    var npcs: [NPC] = []
    var node: SCNNode!
    
    let cache = HybridCache(name: "Tiles", config: Config(
        frontKind: .memory,
        backKind: .disk,
        expiry: .date(Date().addingTimeInterval(100000)),
        maxSize: 10000))

    init(tileKey: Vector2, mapNode: SCNNode, primordialTile: Vector2) {
        self.tileKey = tileKey
        self.position = Vector2(tileKey.x - primordialTile.x, primordialTile.y - tileKey.y) * 611
        
        Logging.info(data: "TILE \(tileKey) @ \(self.position)")
        
        node = SCNNode()
        node.position = SCNVector3(x: position.x, y: position.y, z: 0)
        mapNode.addChildNode(node)
        
        cache.object("\(tileKey.x)-\(tileKey.y)") { (cachedTileData: String?) in
            if let tileData = cachedTileData {
                self.data = SwiftyJSON.JSON.parse(tileData)
                self.render()
            } else {
                API.get(endpoint: "tile/\(Int(tileKey.x))/\(Int(tileKey.y))", callback: { (data) in
                    self.data = data["data"]
                    self.cache.add("\(tileKey.x)-\(tileKey.y)", object: self.data.rawString()!)
                    DispatchQueue.main.async {
                        self.render()
                    }
                })
            }
        }
       
        gridPoint = GridPoint(tile: self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleHomebaseNotification), name: NSNotification.Name(rawValue: "new-homebase"), object: nil)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "check-tile-homebase"), object: self)
    }
    
    @objc func handleHomebaseNotification(note: NSNotification) {
      (note.object as! Homebase).placeHomebaseIfOn(mapTile: self)
    }
    
    func render() {
        let mapTile = SCNPlane(width: 611, height: 611)
        mapTile.firstMaterial!.diffuse.contents = texture()
        let features = SCNNode(geometry: mapTile)
        node.addChildNode(features)
        
        data["npcs"].array!.forEach { (npcData) in
            let npc = NPC(data: npcData, tileNode: node)
            self.npcs.append(npc)
        }
    }
    
    func drawShapes(context: CGContext, field: String) {
        context.setStrokeColor(UIColor(red:0.20, green:0.60, blue:0.88, alpha:1.0).cgColor)
        context.setLineWidth(2.0)
/*if (shape["type"].string! == "polygon") {
 
 for polygon in shape["coords"].array! {
 /*let shape2 = CAShapeLayer()
 
 layer.addSublayer(shape2)
 shape2.opacity = 0.5
 shape2.lineWidth = 1
 shape2.lineJoin = kCALineJoinMiter
 shape2.strokeColor = UIColor(hue: 0.786, saturation: 0.79, brightness: 0.53, alpha: 1.0).cgColor
 shape2.fillColor = UIColor(hue: 0.786, saturation: 0.15, brightness: 0.89, alpha: 1.0).cgColor
 
 let path = UIBezierPath()
 
 let thePoint = CGPoint(x: (polygon.array?[0].array?[0].double!)!, y: (polygon.array?[0].array?[1].double!)!)
 path.move(to: thePoint)
 
 for point in polygon.array! {
 let thePoint = CGPoint(x: (point.array?[0].double!)!, y: (point.array?[1].double!)!)
 path.addLine(to: thePoint)
 }
 
 path.close()
 shape2.path = path.cgPath*/
 }
 } else*/
        
        for shape in data[field].array!.filter({ $0["type"].string! == "linestring" }) {
            let thePoint = CGPoint(x: (shape["coords"].array![0].array![0].double!), y: (shape["coords"].array![0].array![1].double!))
            context.move(to: thePoint)
            for point in shape["coords"].array! {
                let thePoint = CGPoint(x: (point.array![0].double!), y: (point.array![1].double!))
                context.addLine(to: thePoint)
                context.move(to: thePoint)
            }
        }
        context.strokePath()
    }
    
    func texture() -> UIImage {
        let scale: CGFloat = 0
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 611, height: 611), false, scale)
        let context = UIGraphicsGetCurrentContext()!
        
        context.setFillColor(UIColor(red:0.11, green:0.11, blue:0.13, alpha:1.0).cgColor)
        context.setLineWidth(0)
        context.addRect(CGRect(x: 0, y: 0, width: 611, height: 611))
        context.drawPath(using: .fillStroke)
        
        drawShapes(context: context, field: "roads")
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }

}
