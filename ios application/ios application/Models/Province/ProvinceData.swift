//
//  ProvinceData.swift
//  ios application
//
//  Created by student5 on 2026-07-16.
//

import Foundation
import MapKit


enum ProvinceData {

    static let provinces: [ProvinceShape] = [
        ProvinceShape(
            province : .western,
            coordinates: [
                CLLocationCoordinate2D(latitude: 7.30, longitude: 79.85),
                CLLocationCoordinate2D(latitude: 7.10, longitude: 80.10),
                CLLocationCoordinate2D(latitude: 6.75, longitude: 80.20),
                CLLocationCoordinate2D(latitude: 6.40, longitude: 80.00),
                CLLocationCoordinate2D(latitude: 6.55, longitude: 79.80),
                CLLocationCoordinate2D(latitude: 6.95, longitude: 79.75)
            ]
        ),

        ProvinceShape(
            province : .central,
            coordinates: [
                CLLocationCoordinate2D(latitude: 7.60, longitude: 80.45),
                CLLocationCoordinate2D(latitude: 7.55, longitude: 80.85),
                CLLocationCoordinate2D(latitude: 7.15, longitude: 81.05),
                CLLocationCoordinate2D(latitude: 6.85, longitude: 80.75),
                CLLocationCoordinate2D(latitude: 7.00, longitude: 80.35)
            ]
        ),

        ProvinceShape(
            province : .southern,
            coordinates: [
                CLLocationCoordinate2D(latitude: 6.55, longitude: 79.90),
                CLLocationCoordinate2D(latitude: 6.45, longitude: 80.45),
                CLLocationCoordinate2D(latitude: 6.35, longitude: 81.00),
                CLLocationCoordinate2D(latitude: 5.95, longitude: 81.00),
                CLLocationCoordinate2D(latitude: 5.95, longitude: 80.20)
            ]
        ),

        ProvinceShape(
            province : .northern,
            coordinates: [
                CLLocationCoordinate2D(latitude: 9.85, longitude: 79.95),
                CLLocationCoordinate2D(latitude: 9.80, longitude: 80.45),
                CLLocationCoordinate2D(latitude: 9.20, longitude: 80.85),
                CLLocationCoordinate2D(latitude: 8.60, longitude: 80.50),
                CLLocationCoordinate2D(latitude: 8.70, longitude: 79.90)
            ]
        ),

        ProvinceShape(
            province : .eastern,
            coordinates: [
                CLLocationCoordinate2D(latitude: 8.80, longitude: 81.00),
                CLLocationCoordinate2D(latitude: 8.40, longitude: 81.55),
                CLLocationCoordinate2D(latitude: 7.20, longitude: 81.85),
                CLLocationCoordinate2D(latitude: 6.20, longitude: 81.50),
                CLLocationCoordinate2D(latitude: 7.00, longitude: 81.00)
            ]
        ),

        ProvinceShape(
            province : .northWestern,
            coordinates: [
                CLLocationCoordinate2D(latitude: 8.30, longitude: 79.75),
                CLLocationCoordinate2D(latitude: 8.30, longitude: 80.45),
                CLLocationCoordinate2D(latitude: 7.50, longitude: 80.65),
                CLLocationCoordinate2D(latitude: 7.20, longitude: 80.10),
                CLLocationCoordinate2D(latitude: 7.50, longitude: 79.75)
            ]
        ),

        ProvinceShape(
            province : .northCentral,
            coordinates: [
                CLLocationCoordinate2D(latitude: 8.95, longitude: 80.30),
                CLLocationCoordinate2D(latitude: 8.85, longitude: 81.10),
                CLLocationCoordinate2D(latitude: 8.10, longitude: 81.35),
                CLLocationCoordinate2D(latitude: 7.45, longitude: 80.85),
                CLLocationCoordinate2D(latitude: 7.80, longitude: 80.35)
            ]
        ),

        ProvinceShape(
            province : .uva,
            coordinates: [
                CLLocationCoordinate2D(latitude: 7.40, longitude: 80.90),
                CLLocationCoordinate2D(latitude: 7.35, longitude: 81.45),
                CLLocationCoordinate2D(latitude: 6.50, longitude: 81.55),
                CLLocationCoordinate2D(latitude: 6.35, longitude: 80.95),
                CLLocationCoordinate2D(latitude: 6.85, longitude: 80.65)
            ]
        ),

        ProvinceShape(
            province : .sabaragamuwa,
            coordinates: [
                CLLocationCoordinate2D(latitude: 7.30, longitude: 80.25),
                CLLocationCoordinate2D(latitude: 7.15, longitude: 80.85),
                CLLocationCoordinate2D(latitude: 6.35, longitude: 80.80),
                CLLocationCoordinate2D(latitude: 6.25, longitude: 80.25),
                CLLocationCoordinate2D(latitude: 6.75, longitude: 80.00)
            ]
        )
    ]
}
