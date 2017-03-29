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
    let locationManager = CLLocationManager()
    static var last: Vector2!
    
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
        LocationMaster.last = Vector2(Scalar(manager.location!.coordinate.latitude), Scalar(manager.location!.coordinate.longitude))

    }

}
