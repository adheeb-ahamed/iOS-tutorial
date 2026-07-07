//The main purpose of this Location Group is to groupify all the location it contains the data of all the played game


//  LocationGroup.swift
//  ios application
//
//  Created by student5 on 2026-07-07.
//


import Foundation
import CoreLocation


struct LocationGroup: Identifiable, Hashable {
    
    let id = UUID()
    
    let coordinates : CLLocationCoordinate2D
    
    var sessions : [GameSessionModel]
    
    
    
    //Manually hashing 
    static func == (lhs: LocationGroup, rhs: LocationGroup) -> Bool {
        lhs.id == rhs.id
    }


    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}
