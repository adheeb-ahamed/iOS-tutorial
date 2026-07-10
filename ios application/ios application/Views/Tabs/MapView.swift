import SwiftUI
import MapKit

struct MapView: View {

    @StateObject private var manager = GameSessionManager.shared

    @State private var cameraPosition: MapCameraPosition = .automatic
    
    @State private var selectedLocation: LocationGroup?
    
    // Group sessions by exact coordinate string and build LocationGroup models
    var groupedLocations: [LocationGroup] {
        let grouped = Dictionary(grouping: manager.sessions) { session in
            "\(session.latitude),\(session.longitude)"
        }
        
        return grouped.map { (_, sessions) in
            LocationGroup(
                coordinates: CLLocationCoordinate2D(
                    latitude: sessions[0].latitude,
                    longitude: sessions[0].longitude
                ),
                sessions: sessions
            )
        }
    }

    var body: some View {
        Map(position: $cameraPosition, selection: $selectedLocation) {
            ForEach(groupedLocations) { location in
                Marker(
                    "\(location.sessions.count) Games",
                    systemImage: "gamecontroller.fill",
//                    tint: location.sessions.last!.mode.color,   //this means it shows the pin color of last played game
                    coordinate: location.coordinates
                )
                .tint(location.sessions.last?.mode.color ?? .gray)
                .tag(location)
            }
        }
        .navigationTitle("Game Sessions")
        .onAppear {
            print(GameSessionManager.shared.sessions.count)
            
            for s in manager.sessions {
                print("session coords:", s.latitude, s.longitude)
            }
            
            if let first = manager.sessions.first {
                cameraPosition = .region(
                    MKCoordinateRegion(
                        center: CLLocationCoordinate2D(
                            latitude: first.latitude,
                            longitude: first.longitude
                        ),
                        span: MKCoordinateSpan(
                            latitudeDelta: 0.02,
                            longitudeDelta: 0.02
                        )
                    )
                )
            }
        }
        .sheet(item: $selectedLocation) { location in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Game History")
                        .font(.system(.title2, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .padding(.bottom, 4)

                    ForEach(location.sessions.sorted { $0.timestamp > $1.timestamp }) { session in
                        SessionCard(session: session)
                    }
                }
                .padding()
            }
            .background(Color(uiColor: .systemGroupedBackground).ignoresSafeArea())
        }
    }
}

