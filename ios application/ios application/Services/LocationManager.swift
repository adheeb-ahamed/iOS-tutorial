//
// THIS IS USED TO ASK PERMISSION FOR GPS LOCATION


//  LocationManager.swift
//  ios application
//
//  Created by Student 3 on 2026-07-06.
//

import Foundation
import CoreLocation
import Combine


class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    
    static let shared = LocationManager()
    
    private let manager =  CLLocationManager()
    
    
    @Published var latitude : Double = 0.0
    @Published var longitude : Double = 0.0
    
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestPermission() {
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else { return }
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
        
        print("Current location:", latitude, longitude)
    }
    
}


    
