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
import SwiftyJSON

class MapTile {
    var data: SwiftyJSON.JSON = JSON.null
    let tileKey: Vector2
    let position: Vector2
    let latLon: Vector2
    let latLonInMeters: Vector2
    var node: SCNNode!
    var lines: [(Double, Double)] = []

    init(tileKey: Vector2, mapNode: SCNNode, primordialTile: Vector2) {
        self.tileKey = tileKey
        self.position = Vector2(tileKey.x - primordialTile.x, primordialTile.y - tileKey.y) * 611
        self.latLon = Utils.tileToLatLon(tile: tileKey)
        self.latLonInMeters = Utils.latLonToMeters(coord: self.latLon)
        
        Logging.info(data: "TILE \(tileKey) @ \(self.position)")
        
        node = SCNNode()
        node.position = SCNVector3(x: position.x, y: position.y, z: 0)
        mapNode.addChildNode(node)
        

        API.get(endpoint: "http://tile.mapzen.com/mapzen/vector/v1/all/16/\(Int(tileKey.x))/\(Int(tileKey.y)).json?api_key=mapzen-YMzZVyX", callback: { (data) in
            self.data = data
            DispatchQueue.main.async {
                self.render()
            }
        })

        
    }
    
  
    
    func render() {
        let mapTile = SCNPlane(width: 611, height: 611)
        let txt = texture()
        mapTile.firstMaterial!.diffuse.contents = txt
        let features = SCNNode(geometry: mapTile)
        node.addChildNode(features)
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
        
        for feature in data[field]["features"].array! {
            if feature["geometry"]["type"].string! == "LineString" {
                let coords = feature["geometry"]["coordinates"].array!
                let thePoint = Utils.latLonToMeters(coord: Vector2(x: coords[0].array![1].float!, y: coords[0].array![0].float!)) - latLonInMeters
                context.move(to: CGPoint(x: Double(abs(thePoint.x)), y: Double(abs(thePoint.y))))
                for point in coords {
                    let thePointInMeters = Utils.latLonToMeters(coord: Vector2(x: point.array![1].float!, y: point.array![0].float!)) - latLonInMeters
                    let thePoint = CGPoint(x: Double(abs(thePointInMeters.x)), y: Double(abs(thePointInMeters.y)))
                    context.addLine(to: thePoint)
                    context.move(to: thePoint)
                }
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
        
        if self.data != JSON.null {
            drawShapes(context: context, field: "roads")
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    
}
