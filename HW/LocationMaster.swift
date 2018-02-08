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
    private static var last: (Double, Double) = (0.0, 0.0)
    
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
        LocationMaster.last = (manager.location!.coordinate.latitude, manager.location!.coordinate.longitude)

    }
    
    static func getLast() -> (Double, Double) {
        if Constants.DEBUG {
            return Constants.DEBUG_LAST
        }
        return LocationMaster.last
    }

}
