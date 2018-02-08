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
    let tileKey: (Int, Int)
    let position: (Int, Int)
    let latLon: (Double, Double)
    let latLonInMeters: (Double, Double)
    var node: SCNNode!
    var lines: [(Double, Double)] = []

    init(tileKey: (Int, Int), mapNode: SCNNode, primordialTile: (Int, Int)) {
        self.tileKey = tileKey
        self.position = ((tileKey.0 - primordialTile.0) * 611, (primordialTile.1 - tileKey.1) * 611)
        self.latLon = Utils.tileToLatLon(tile: tileKey)
        self.latLonInMeters = Utils.latLonToMeters(coord: self.latLon)
        
        Logging.info(data: "TILE \(tileKey) @ \(self.position)")
        
        node = SCNNode()
        node.position = SCNVector3(x: Float(position.0), y: Float(position.1), z: 0)
        mapNode.addChildNode(node)
        

        API.get(endpoint: "http://tile.mapzen.com/mapzen/vector/v1/all/16/\(Int(tileKey.0))/\(Int(tileKey.1)).json?api_key=mapzen-YMzZVyX", callback: { (data) in
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
                let pointLatLon = Utils.latLonToMeters(coord: (coords[0].array![1].double!, coords[0].array![0].double!))
                let thePoint = (pointLatLon.0 - latLonInMeters.0, pointLatLon.1 - latLonInMeters.1)
                context.move(to: CGPoint(x: abs(thePoint.0), y: abs(thePoint.1)))
                for point in coords {
                    let pointLatLon = Utils.latLonToMeters(coord: (point.array![1].double!, point.array![0].double!))
                    let thePointInMeters = (pointLatLon.0 - latLonInMeters.0, pointLatLon.1 - latLonInMeters.1)
                    let thePoint = CGPoint(x: abs(thePointInMeters.0), y: abs(thePointInMeters.1))
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
