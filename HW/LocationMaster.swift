//
//  LocationMaster.swift
//  HW
//
//  Created by Adrian Nenu on 28/03/2017.
//  Copyright © 2017 Adrian Nenu. All rights reserved.
//

import Foundation
import CoreLocation

class LocationMaster: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    private static var last: Vector2 = Vector2.zero
    private static var debugLast: Vector2 = Vector2(53.45884, -2.22993)
    static var debug: Bool = false
    
    override init() {
        super.init()

        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        LocationMaster.last = Vector2(Float(manager.location!.coordinate.latitude), Float(manager.location!.coordinate.longitude))

    }
    
    static func getLast() -> Vector2 {
        if LocationMaster.debug {
            return LocationMaster.debugLast
        }
        return LocationMaster.last
    }

}
