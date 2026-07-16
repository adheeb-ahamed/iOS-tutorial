import SwiftUI
import MapKit

struct MapView: View {
    @StateObject private var manager = GameSessionManager.shared
    @StateObject private var explorerManager = ProvinceExplorerManager.shared
    
    @State private var provinceForAlert: SriLankaProvince?

    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 7.8731, longitude: 80.7718),
            span: MKCoordinateSpan(latitudeDelta: 4.5, longitudeDelta: 4.5)
        )
    )

    @State private var selectedLocation: LocationGroup?

    private let provinceShapes = ProvinceData.provinces

    // Break out grouped locations to help the type-checker
    private var groupedLocations: [LocationGroup] {
        let grouped = Dictionary(grouping: manager.sessions) { session in
            "\(session.latitude),\(session.longitude)"
        }
        return grouped.compactMap { _, sessions in
            guard let first = sessions.first else { return nil }
            return LocationGroup(
                coordinates: CLLocationCoordinate2D(latitude: first.latitude, longitude: first.longitude),
                sessions: sessions
            )
        }
    }

    // Extract province overlays to reduce complexity in the Map builder
    @MapContentBuilder
    private var provinceOverlays: some MapContent {
        ForEach(provinceShapes) { province in
            MapPolygon(coordinates: province.coordinates)
                .foregroundStyle(
                    explorerManager.isExplored(province.province)
                    ? Color.clear
                    : Color.gray.opacity(0.65)
                )
                .stroke(Color.white.opacity(0.8), lineWidth: 1.5)
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
