//
//  GridPoint.swift
//  HW
//
//  Created by Adrian Nenu on 28/03/2017.
//  Copyright © 2017 Adrian Nenu. All rights reserved.
//

import Foundation
import UIKit
import SwiftHTTP

class GridPoint: UIView {
    var tileKey: Vector2 = Vector2.zero
    //var neighbouringPoints: [Vector2] = []
    var gridPointPosition: Vector2!
    var state: Int = 1
    var timer: Timer!
    
    static func pseudorrandomPosition(of: Vector2) -> Vector2 {
        srand48(Int(of.x) * Int(of.y) * Int(10000))
        return Vector2(Float(611) / 2, Float(611) / 2) +
            Vector2(Float(200 - Int((drand48() * 1000).truncatingRemainder(dividingBy: 500))),
                    Float(200 - Int((drand48() * 1000).truncatingRemainder(dividingBy: 500))))
    }
    
    init(tileKey: Vector2) {
        self.tileKey = tileKey
        let gridPointPosition = GridPoint.pseudorrandomPosition(of: tileKey)
        
        super.init(frame: CGRect(x: Double(gridPointPosition.x), y: Double(gridPointPosition.y), width: 20, height: 20))
        self.gridPointPosition = gridPointPosition
        print("GP \(tileKey) \(gridPointPosition)")
        self.setState(state: 1)

        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.someAction (_:)))
        self.addGestureRecognizer(gesture)
        
       /* var gpAbsolute = Utils.latLonToMeters(coord: Utils.tileToLatLon(tile: tileKey))
            gpAbsolute = Vector2(abs(gpAbsolute.x), abs(gpAbsolute.y))
        for neigh in [ Vector2(-1, 0), Vector2(0, -1), Vector2(1, 0), Vector2(0, 1)] {
            let current = tileKey + neigh
            let currentRelative = GridPoint.pseudorrandomPosition(of: current)
            var neighAbsolute = Utils.latLonToMeters(coord: Utils.tileToLatLon(tile: current))
            neighAbsolute = Vector2(abs(neighAbsolute.x), abs(neighAbsolute.y))
            neighAbsolute = neighAbsolute + currentRelative
            
            neighbouringPoints.append(neighAbsolute - gpAbsolute)
        }
        print (neighbouringPoints)*/
    }
    
    public func setState(state: Int, remaining: Int = 0) {
        self.state = state
        DispatchQueue.main.async {
            if self.timer != nil {
                self.timer.invalidate()
            }
            switch self.state {
            case 2:
                self.backgroundColor = UIColor.yellow
                Timer.scheduledTimer(timeInterval: TimeInterval(remaining), target: self, selector: #selector(self.resetState), userInfo: nil, repeats: false)
                break
            case 1:
                self.backgroundColor = UIColor.green
                break
            case 3:
                self.backgroundColor = UIColor.red
                Timer.scheduledTimer(timeInterval: TimeInterval(remaining), target: self, selector: #selector(self.resetState), userInfo: nil, repeats: false)

                break
            default: break
            }
        }
        
    }
    
    func resetState(timer: Timer) {
        self.setState(state: 1)
    }
    
    func someAction(_ sender: UITapGestureRecognizer) {
        GridPointInterface.init().show(gridPoint: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /*override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(UIColor(red:1, green:0.28, blue:0.28, alpha:1.0).cgColor)
        context.setLineWidth(0)
        context.addRect(rect)
        context.drawPath(using: .fillStroke)
        
        context.setStrokeColor(UIColor(red:0.20, green:0.60, blue:0.88, alpha:1.0).cgColor)
        context.setLineWidth(2.0)
        
        for point in neighbouringPoints {
            context.move(to: CGPoint(x: 10, y: 10))
            context.addLine(to: CGPoint(x: Double(point.x), y: Double(point.y)))
            context.strokePath()
        }
    }*/
    
}
