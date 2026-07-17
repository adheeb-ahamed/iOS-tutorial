//
//  ProvinceGeoJSONModel.swift
//  ios application
//
//  Created by student5 on 2026-07-16.
//

import Foundation
import MapKit

struct ProvinceGeoJSONShape: Identifiable {
    let id = UUID()

    let province: SriLankaProvince
    let polygons: [MKPolygon]
}
