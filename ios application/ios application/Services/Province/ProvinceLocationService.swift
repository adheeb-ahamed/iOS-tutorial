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

    private let provinces = ProvinceGeoJSONLoader.load()

    func provinceName(
        for coordinate: CLLocationCoordinate2D
    ) -> SriLankaProvince? {

        for province in provinces {
            for polygon in province.polygons {
                if contains(
                    coordinate,
                    inside: polygon
                ) {
                    return province.province
                }
            }
        }

        return nil
    }

    private func contains(
        _ coordinate: CLLocationCoordinate2D,
        inside polygon: MKPolygon
    ) -> Bool {

        let renderer = MKPolygonRenderer(polygon: polygon)

        let mapPoint = MKMapPoint(coordinate)
        let rendererPoint = renderer.point(for: mapPoint)

        return renderer.path.contains(rendererPoint)
    }
}
