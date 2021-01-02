//
//  Utils.swift
//  HW
//
//  Created by Adrian Nenu on 27/03/2017.
//  Copyright © 2017 Adrian Nenu. All rights reserved.
//

import Foundation

import SceneKit

extension SCNNode {
    func parentOf<T>(type: T.Type) -> T? {
        var parent: SCNNode? = self
        repeat {
            if let node = parent as? T {
                return node
            }
            parent = parent?.parent
        } while parent != nil
        return nil
    }
}

class Utils {
    
    static func vectorFrom(json: JSON) -> Vector2 {
        return Vector2(x: json[0].float!, y: json[1].float!)
    }
    
    static func distanceInMetersBetween(latLon1: (Double, Double), latLon2: (Double, Double)) -> (Double, Double) {
        let m1 = latLonToMeters(coord: latLon1)
        let m2 = latLonToMeters(coord: latLon2)
        return (m1.0 - m2.0, m1.1 - m2.1)
    }
    
    static func tileToMeters(tile: (Int, Int)) -> (Double, Double) {
        return latLonToMeters(coord: tileToLatLon(tile: tile))
    }
    
    static func latLonToMeters(coord: (Double, Double)) -> (Double, Double) {
        let earthRadius: Double = 6378137
        let originShift = (2 * Double.pi * earthRadius / 2)
        
        let x = (coord.1 * originShift / 180.0)
        var y = (log(tan((90 + coord.0) * Double.pi / 360)) / (Double.pi / 180))
        y = (y * originShift / 180.0)
        
        return (abs(x), abs(y))
    }
    
    static func  latLonToTile(coord: (Double, Double))  -> (Int, Int) {
        let zoom: Double = pow(2, 16);
        
        let x = floor(((coord.1 + 180) / 360) * zoom)
        let y = floor((1 - log(tan(deg2rad(angle: coord.0)) + 1 / cos(deg2rad(angle: coord.0))) / Double.pi)/2 * zoom)
        return (Int(x), Int(y))
    }
    
    static func tileToLatLon(tile: (Int, Int)) -> (Double, Double) {
        let n: Double = pow (2, 16)
        let lon_deg = (Double(tile.0) / n * 360.0 - 180.0)
        let lat_deg = rad2deg (angle: atan (sinh (Double.pi * (1 - 2 * Double(tile.1) / n))))
        return (lat_deg, lon_deg)
    }
    
    static func rad2deg(angle: Double) -> Double {
        return angle * (180.0 / Double.pi)
    }
    
    static func deg2rad(angle: Double) -> Double {
        return (Double.pi / 180) * angle;
    }
}
