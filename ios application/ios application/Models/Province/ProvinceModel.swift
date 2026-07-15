//
//  provinceModel.swift
//  Velocity
//
//  Created by Student 3 on 2026-07-15.
//

import Foundation
import MapKit

struct ProvinceShape: Identifiable {
    let id = UUID()
    let name: String
    let coordinates: [CLLocationCoordinate2D]
}
