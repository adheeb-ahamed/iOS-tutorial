import Foundation
import MapKit

enum ProvinceGeoJSONLoader {

    static func load() -> [ProvinceGeoJSONShape] {
        guard let fileURL = Bundle.main.url(
            forResource: "SriLankaProvinces",
            withExtension: "geojson"
        ) else {
            print("GeoJSON file could not be found.")
            return []
        }

        do {
            let data = try Data(contentsOf: fileURL)
            let objects = try MKGeoJSONDecoder().decode(data)

            var provinceShapes: [ProvinceGeoJSONShape] = []

            for object in objects {
                guard let feature = object as? MKGeoJSONFeature else {
                    continue
                }

                guard let provinceName = getProvinceName(
                    from: feature.properties
                ) else {
                    print("Province name not found.")
                    continue
                }

                guard let province = SriLankaProvince.from(
                    name: provinceName
                ) else {
                    continue
                }

                let polygons = getPolygons(
                    from: feature.geometry
                )

                guard !polygons.isEmpty else {
                    print("No polygons found for \(provinceName)")
                    continue
                }

                provinceShapes.append(
                    ProvinceGeoJSONShape(
                        province: province,
                        polygons: polygons
                    )
                )
            }

            print("Loaded \(provinceShapes.count) provinces")

            return provinceShapes

        } catch {
            print("Failed to decode GeoJSON: \(error)")
            return []
        }
    }

    private static func getProvinceName(
        from propertiesData: Data?
    ) -> String? {
        guard let propertiesData else {
            return nil
        }

        do {
            let jsonObject = try JSONSerialization.jsonObject(
                with: propertiesData
            )

            guard let properties = jsonObject as? [String: Any] else {
                return nil
            }

            return properties["shapeName"] as? String

        } catch {
            print("Failed to read GeoJSON properties: \(error)")
            return nil
        }
    }

    private static func getPolygons(
        from geometry: [MKShape & MKGeoJSONObject]
    ) -> [MKPolygon] {
        var polygons: [MKPolygon] = []

        for shape in geometry {
            if let polygon = shape as? MKPolygon {
                polygons.append(polygon)
            } else if let multiPolygon = shape as? MKMultiPolygon {
                polygons.append(contentsOf: multiPolygon.polygons)
            }
        }

        return polygons
    }
}
