//
//  Tile.swift
//  HW
//
//  Created by Adrian Nenu on 27/03/2017.
//  Copyright © 2017 Adrian Nenu. All rights reserved.
//
/*
import Foundation
import UIKit
import SwiftyJSON

class Tile2D: UIView {
    var data: JSON = JSON.null
    var tileKey: Vector2 = Vector2.zero
    var gridPoint: GridPoint!
    var npcs: [NPCView] = []
    
    init(tileKey: Vector2) {
        self.tileKey = tileKey
        
        let delta = (tileKey - WorldViewController.primordialTile) * 611.5 + Vector2(5000, 5000)
        super.init(frame: CGRect(x: Double(delta.x), y: Double(delta.y), width: 611.5, height: 611.5))
        
        gridPoint = GridPoint(tileKey: tileKey)
        self.addSubview(gridPoint)
        
        Homebase.placeIfOn(mapTile: self)
        
        if WorldViewController.tilesDataCache[tileKey] != nil {
            self.data = WorldViewController.tilesDataCache[tileKey]!
            renderTile()
        } else {
            WorldViewController.tilesDataCache[tileKey] = JSON.null
            API.get(endpoint: "tile/\(Int(tileKey.x))/\(Int(tileKey.y))", callback: { (data) in
                WorldViewController.tilesDataCache[tileKey] = data["data"]
                self.data = data["data"]
                DispatchQueue.main.async {
                    self.renderTile()
                }
            })
        }
    }

    func renderTile() {
        self.setNeedsDisplay()
        data["npcs"].array!.forEach { (npcData) in
            let npc = NPCView(npc: NPC(data: npcData))
            self.npcs.append(npc)
            addSubview(npc)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func drawShapes(field: String) {
        let context = UIGraphicsGetCurrentContext()!
        context.setStrokeColor(UIColor(red:0.20, green:0.60, blue:0.88, alpha:1.0).cgColor)
        context.setLineWidth(2.0)

        for var shape in data[field].array! {
            if (shape["type"].string! == "polygon") {

                for polygon in shape["coords"].array! {
                    
                    let shape2 = CAShapeLayer()
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
                    shape2.path = path.cgPath
                }
            } else if (shape["type"].string! == "linestring") {
                
                let thePoint = CGPoint(x: (shape["coords"].array?[0].array?[0].double!)!, y: (shape["coords"].array?[0].array?[1].double!)!)
                context.move(to: thePoint)
                for point in shape["coords"].array! {
                    let thePoint = CGPoint(x: (point.array?[0].double!)!, y: (point.array?[1].double!)!)
                    context.addLine(to: thePoint)
                    context.strokePath()
                    
                    context.move(to: thePoint)
                }
            }
            
            
        }
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(UIColor(red:0.32, green:0.28, blue:0.28, alpha:1.0).cgColor)
        context.setLineWidth(0)
        context.addRect(rect)
        context.drawPath(using: .fillStroke)
        
        if data != JSON.null {
            //    drawShapes(field: "buildings")
            drawShapes(field: "roads")
            //  drawShapes(field: "water")
        }
    }
}
*/
