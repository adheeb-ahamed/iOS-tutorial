import SwiftUI
import MapKit

struct MapView: View {
    @StateObject private var manager = GameSessionManager.shared
    @StateObject private var explorerManager = ProvinceExplorerManager.shared
    
    private let provinceShapes = ProvinceGeoJSONLoader.load()
    
    @State private var provinceForAlert: SriLankaProvince?

    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 7.8731, longitude: 80.7718),
            span: MKCoordinateSpan(latitudeDelta: 4.5, longitudeDelta: 4.5)
        )
    )

    @State private var selectedLocation: LocationGroup?
    
    private var latestSession: GameSessionModel? {
        manager.sessions
            .filter {
                $0.latitude != 0 &&
                $0.longitude != 0
            }
            .max {
                $0.timestamp < $1.timestamp
            }
    }


    // Break out grouped locations to help the type-checker
    private var groupedLocations: [LocationGroup] {
        let validSessions = manager.sessions.filter {
            $0.latitude != 0 &&
            $0.longitude != 0
        }

        let grouped = Dictionary(
            grouping: validSessions
        ) { session in
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
    
    private func moveCameraToLatestGame() {
        guard let latestSession else {
            return
        }

        let coordinate = CLLocationCoordinate2D(
            latitude: latestSession.latitude,
            longitude: latestSession.longitude
        )

        withAnimation {
            cameraPosition = .region(
                MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(
                        latitudeDelta: 0.15,
                        longitudeDelta: 0.15
                    )
                )
            )
        }
    }

    // Extract province overlays to reduce complexity in the Map builder
    @MapContentBuilder
    private var provinceOverlays: some MapContent {
        ForEach(provinceShapes) { provinceShape in
            if !explorerManager.isExplored(provinceShape.province) {
                ForEach(
                    Array(provinceShape.polygons.enumerated()),
                    id: \.offset
                ) { _, polygon in
                    MapPolygon(polygon)
                        .foregroundStyle(Color.gray.opacity(0.65))
                        .stroke(
                            Color.white.opacity(0.8),
                            lineWidth: 1.2
                        )
                }
            }
        }
    }

    // Extract markers to reduce complexity in the Map builder
    @MapContentBuilder
    private var sessionMarkers: some MapContent {
        ForEach(groupedLocations) { location in
            Marker(
                "\(location.sessions.count) Games",
                systemImage: "gamecontroller.fill",
                coordinate: location.coordinates
            )
            .tint(location.sessions.last?.mode.color ?? .gray)
            .tag(location)
        }
    }
    
    

    var body: some View {
        ZStack {
            Map(position: $cameraPosition, selection: $selectedLocation) {
                provinceOverlays
                sessionMarkers
            }
            .mapStyle(.standard)
            .sheet(item: $selectedLocation) { location in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Game History")
                            .font(.title2)
                            .fontWeight(.bold)

                        ForEach(location.sessions.sorted { $0.timestamp > $1.timestamp }) { session in
                            SessionCard(session: session)
                        }
                    }
                    .padding()
                }
            }

            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Explore Sri Lanka")
                            .font(.headline)

                        Text("\(explorerManager.exploredCount) / \(explorerManager.totalProvinceCount)")
                            .font(.subheadline)
                            .fontWeight(.semibold)

                        ProgressView(value: explorerManager.progress)
                    }
                    Spacer()
                }
                .padding()
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding()

                Spacer()
            }
        }
        .navigationTitle("Map")
        .onAppear {
            moveCameraToLatestGame()
        }
        .onReceive(
            explorerManager.$newlyUnlockedProvince
        ) { province in
            guard let province else {
                return
            }

            provinceForAlert = province
        }
        
    }
}

