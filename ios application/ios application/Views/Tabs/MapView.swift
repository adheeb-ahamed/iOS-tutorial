import SwiftUI
import MapKit

struct MapView: View {

    @StateObject private var manager = GameSessionManager.shared

    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: 7.8731,
                longitude: 80.7718
            ),
            span: MKCoordinateSpan(
                latitudeDelta: 4.5,
                longitudeDelta: 4.5
            )
        )
    )

    @State private var selectedLocation: LocationGroup?

    private let provinceShapes: [ProvinceShape] = [
        ProvinceShape(
            name: "Western",
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
            name: "Central",
            coordinates: [
                CLLocationCoordinate2D(latitude: 7.60, longitude: 80.45),
                CLLocationCoordinate2D(latitude: 7.55, longitude: 80.85),
                CLLocationCoordinate2D(latitude: 7.15, longitude: 81.05),
                CLLocationCoordinate2D(latitude: 6.85, longitude: 80.75),
                CLLocationCoordinate2D(latitude: 7.00, longitude: 80.35)
            ]
        ),

        ProvinceShape(
            name: "Southern",
            coordinates: [
                CLLocationCoordinate2D(latitude: 6.55, longitude: 79.90),
                CLLocationCoordinate2D(latitude: 6.45, longitude: 80.45),
                CLLocationCoordinate2D(latitude: 6.35, longitude: 81.00),
                CLLocationCoordinate2D(latitude: 5.95, longitude: 81.00),
                CLLocationCoordinate2D(latitude: 5.95, longitude: 80.20)
            ]
        ),

        ProvinceShape(
            name: "Northern",
            coordinates: [
                CLLocationCoordinate2D(latitude: 9.85, longitude: 79.95),
                CLLocationCoordinate2D(latitude: 9.80, longitude: 80.45),
                CLLocationCoordinate2D(latitude: 9.20, longitude: 80.85),
                CLLocationCoordinate2D(latitude: 8.60, longitude: 80.50),
                CLLocationCoordinate2D(latitude: 8.70, longitude: 79.90)
            ]
        ),

        ProvinceShape(
            name: "Eastern",
            coordinates: [
                CLLocationCoordinate2D(latitude: 8.80, longitude: 81.00),
                CLLocationCoordinate2D(latitude: 8.40, longitude: 81.55),
                CLLocationCoordinate2D(latitude: 7.20, longitude: 81.85),
                CLLocationCoordinate2D(latitude: 6.20, longitude: 81.50),
                CLLocationCoordinate2D(latitude: 7.00, longitude: 81.00)
            ]
        ),

        ProvinceShape(
            name: "North Western",
            coordinates: [
                CLLocationCoordinate2D(latitude: 8.30, longitude: 79.75),
                CLLocationCoordinate2D(latitude: 8.30, longitude: 80.45),
                CLLocationCoordinate2D(latitude: 7.50, longitude: 80.65),
                CLLocationCoordinate2D(latitude: 7.20, longitude: 80.10),
                CLLocationCoordinate2D(latitude: 7.50, longitude: 79.75)
            ]
        ),

        ProvinceShape(
            name: "North Central",
            coordinates: [
                CLLocationCoordinate2D(latitude: 8.95, longitude: 80.30),
                CLLocationCoordinate2D(latitude: 8.85, longitude: 81.10),
                CLLocationCoordinate2D(latitude: 8.10, longitude: 81.35),
                CLLocationCoordinate2D(latitude: 7.45, longitude: 80.85),
                CLLocationCoordinate2D(latitude: 7.80, longitude: 80.35)
            ]
        ),

        ProvinceShape(
            name: "Uva",
            coordinates: [
                CLLocationCoordinate2D(latitude: 7.40, longitude: 80.90),
                CLLocationCoordinate2D(latitude: 7.35, longitude: 81.45),
                CLLocationCoordinate2D(latitude: 6.50, longitude: 81.55),
                CLLocationCoordinate2D(latitude: 6.35, longitude: 80.95),
                CLLocationCoordinate2D(latitude: 6.85, longitude: 80.65)
            ]
        ),

        ProvinceShape(
            name: "Sabaragamuwa",
            coordinates: [
                CLLocationCoordinate2D(latitude: 7.30, longitude: 80.25),
                CLLocationCoordinate2D(latitude: 7.15, longitude: 80.85),
                CLLocationCoordinate2D(latitude: 6.35, longitude: 80.80),
                CLLocationCoordinate2D(latitude: 6.25, longitude: 80.25),
                CLLocationCoordinate2D(latitude: 6.75, longitude: 80.00)
            ]
        )
    ]

    var groupedLocations: [LocationGroup] {
        let grouped = Dictionary(grouping: manager.sessions) { session in
            "\(session.latitude),\(session.longitude)"
        }

        return grouped.compactMap { _, sessions in
            guard let first = sessions.first else {
                return nil
            }

            return LocationGroup(
                coordinates: CLLocationCoordinate2D(
                    latitude: first.latitude,
                    longitude: first.longitude
                ),
                sessions: sessions
            )
        }
    }
    
    @State private var exploredProvinceNames: Set<String> = [
        "Western"
    ]

    var body: some View {
        Map(
            position: $cameraPosition,
            selection: $selectedLocation
        ) {

            ForEach(provinceShapes) { province in
                let isExplored = exploredProvinceNames.contains(province.name)

                MapPolygon(coordinates: province.coordinates)
                    .foregroundStyle(
                        isExplored
                        ? Color.clear
                        : Color.gray.opacity(0.65)
                    )
                    .stroke(
                        Color.white.opacity(0.8),
                        lineWidth: 1.5
                    )
            }

            ForEach(groupedLocations) { location in
                Marker(
                    "\(location.sessions.count) Games",
                    systemImage: "gamecontroller.fill",
                    coordinate: location.coordinates
                )
                .tint(
                    location.sessions.last?.mode.color ?? .gray
                )
                .tag(location)
            }
        }
        .mapStyle(.standard)
        .navigationTitle("Province Test")
        .sheet(item: $selectedLocation) { location in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Game History")
                        .font(.title2)
                        .fontWeight(.bold)

                    ForEach(
                        location.sessions.sorted {
                            $0.timestamp > $1.timestamp
                        }
                    ) { session in
                        SessionCard(session: session)
                    }
                }
                .padding()
            }
        }
    }
}
