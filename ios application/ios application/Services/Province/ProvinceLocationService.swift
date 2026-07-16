//
//  ProvinceLocationService.swift
//  ios application
//
//  Created by student5 on 2026-07-16.
//

//This checks if the current location that you are in is explored or not

import Foundation
import MapKit

final class ProvinceLocationService {

    func province(
        for coordinate: CLLocationCoordinate2D
    ) -> SriLankaProvince? {

        for province in ProvinceData.provinces {
            if contains(
                coordinate,
                inside: province.coordinates
            ) {
                return province.province
            }
        }

        return nil
    }

    private func contains(
        _ coordinate: CLLocationCoordinate2D,
        inside polygonCoordinates: [CLLocationCoordinate2D]
    ) -> Bool {

        guard polygonCoordinates.count >= 3 else {
            return false
        }

        let polygon = MKPolygon(
            coordinates: polygonCoordinates,
            count: polygonCoordinates.count
        )

        let renderer = MKPolygonRenderer(polygon: polygon)

        //Converts the latitude and longitude to mapkits
        let mapPoint = MKMapPoint(coordinate)

        let rendererPoint = renderer.point(
            for: mapPoint
        )

        //Check if the location is inside the point
        return renderer.path.contains(rendererPoint)
    }
}
