import SwiftUI
import MapKit

struct MapView: View {

    @StateObject private var manager = GameSessionManager.shared

    @State private var cameraPosition: MapCameraPosition = .automatic

    var body: some View {

        Map(position: $cameraPosition) {

            ForEach(manager.sessions) { session in

                Marker(
                    session.mode.rawValue,
                    coordinate: CLLocationCoordinate2D(
                        latitude: session.latitude,
                        longitude: session.longitude
                    )
                )
            }
        }
        .navigationTitle("Game Sessions")
        .onAppear {

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
    }
}
