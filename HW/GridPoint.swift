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
    var gridPointPosition: Vector2!
    var state: Int = 1
    var timer: Timer!

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(tileKey: Vector2) {
        srand48(Int(tileKey.x) * Int(tileKey.y) * Int(10000))
        
        self.tileKey = tileKey
        let gridPointPosition = Vector2(Float(611) / 2, Float(611) / 2) +
            Vector2(Scalar(200 - Int((drand48() * 1000).truncatingRemainder(dividingBy: 500))),
                    Scalar(200 - Int((drand48() * 1000).truncatingRemainder(dividingBy: 500))))
        super.init(frame: CGRect(x: Double(gridPointPosition.x), y: Double(gridPointPosition.y), width: 20, height: 20))
        self.gridPointPosition = gridPointPosition
        
        self.setState(state: 1)

        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.someAction (_:)))
        self.addGestureRecognizer(gesture)
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
               // self.timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(remaining), repeats: false, block: self.resetState)

                break
            case 1:
                self.backgroundColor = UIColor.green
                break
            case 3:
                self.backgroundColor = UIColor.red
             //   self.timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(remaining), repeats: false, block: self.resetState)
                break
            default: break
            }
        }
        
    }
    
    func resetState(timer: Timer) {
        self.setState(state: 1)
    }
    
    func someAction(_ sender:UITapGestureRecognizer){
        switch self.state {
        case 2:
            API.post(endpoint: "gridPoint/\(Int(self.tileKey.x))/\(Int(self.tileKey.y))/surge", callback: { (data) in
                for tileData in data["data"]["network"].array! {
                    let tile = Vector2(Scalar(tileData["x"].int!), Scalar(tileData["y"].int!))
                    if let mapTile = WorldViewController.mapTiles[tile] {
                        mapTile.gridPoint.setState(state: 3, remaining: data["data"]["remaining"].int!)
                    }
                }
            })
            break
        case 1:
            API.post(endpoint: "gridPoint/\(Int(self.tileKey.x))/\(Int(self.tileKey.y))/hack", callback: { (data) in
                if data["code"].int! == 200 {
                    if data["code"].int! == 200 {
                        self.setState(state: 2, remaining: data["data"]["remaining"].int!)
                    }
                }
            })
            break
        default: break
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
