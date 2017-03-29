//
//  Utils.swift
//  HW
//
//  Created by Adrian Nenu on 27/03/2017.
//  Copyright © 2017 Adrian Nenu. All rights reserved.
//

import Foundation

class Utils {
    static func latLonToMeters(coord: Vector2) -> Vector2 {
        let earthRadius: Float = 6378137
        let originShift = (2 * Float.pi * earthRadius / 2)
        
        let x = (coord.y * originShift / 180.0)
        var y = (log(tan((90 + coord.x) * Float.pi / 360)) / (Float.pi / 180))
        y = (y * originShift / 180.0)
        
        return Vector2(x, y)
    }
    
    static func  latLonToTile(coord: Vector2)  -> Vector2 {
        let zoom: Float = pow(2, 16);
        
        let x = Int(floor(((coord.y + 180) / 360) * zoom))
        let y = Int(floor((1 - log(tan(deg2rad(angle: coord.x)) + 1 / cos(deg2rad(angle: coord.x))) / Float.pi)/2 * zoom))
        return Vector2(Scalar(x), Scalar(y))
    }
    
    static func tileToLatLon(tile: Vector2) -> Vector2 {
        let n: Float = pow (2, 16)
        let lon_deg = (tile.x / n * 360.0 - 180.0)
        let lat_deg = rad2deg (angle: atan (sinh (Float.pi * (1 - 2 * tile.y / n))))
        return Vector2(lat_deg, lon_deg)
    }
    
    static func rad2deg(angle: Float) -> Float {
        return angle * (180.0 / Float.pi)
    }
    
    static func deg2rad(angle: Float) -> Float {
        return (Float.pi / 180) * angle;
    }
}
