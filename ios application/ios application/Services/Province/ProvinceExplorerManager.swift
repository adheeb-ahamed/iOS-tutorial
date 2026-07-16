import Foundation
import Combine
import MapKit

final class ProvinceExplorerManager: ObservableObject {

    static let shared = ProvinceExplorerManager()

    @Published private(set) var exploredProvinceNames: Set<SriLankaProvince> = []

    @Published private(set) var newlyUnlockedProvince: SriLankaProvince?

    private let storageKey = "exploredProvinceNames"

    private let locationService = ProvinceLocationService()

    private init() {
        loadExploredProvinces()
    }

    @discardableResult
    func unlockProvince(named province: SriLankaProvince) -> Bool {
        guard !exploredProvinceNames.contains(province) else {
            return false
        }

        exploredProvinceNames.insert(province)
        newlyUnlockedProvince = province

        saveExploredProvinces()

        return true
    }

    func isExplored(_ province: SriLankaProvince) -> Bool {
        exploredProvinceNames.contains(province)
    }

    private func saveExploredProvinces() {
        let values = exploredProvinceNames.map {
            $0.rawValue
        }

        UserDefaults.standard.set(
            values,
            forKey: storageKey
        )
    }

    private func loadExploredProvinces() {
        let savedValues = UserDefaults.standard.stringArray(
            forKey: storageKey
        ) ?? []

        exploredProvinceNames = Set(
            savedValues.compactMap {
                SriLankaProvince(rawValue: $0)
            }
        )
    }

    var exploredCount: Int {
        exploredProvinceNames.count
    }

    var totalProvinceCount: Int {
        SriLankaProvince.allCases.count
    }

    var progress: Double {
        guard totalProvinceCount > 0 else {
            return 0
        }

        return Double(exploredCount) /
            Double(totalProvinceCount)
    }

    func unlockProvince(
        latitude: Double,
        longitude: Double
    ) -> SriLankaProvince? {

        guard latitude != 0,
              longitude != 0 else {
            print("Invalid game location.")
            return nil
        }

        let coordinate = CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude
        )

        guard let province = locationService.provinceName(
            for: coordinate
        ) else {
            print("No province found for this location.")
            return nil
        }

        let wasNewlyUnlocked = unlockProvince(
            named: province
        )

        if wasNewlyUnlocked {
            print("New province explored: \(province.rawValue)")
            return province
        }

        print("\(province.rawValue) was already explored.")
        return nil
    }

    func clearNewlyUnlockedProvince() {
        newlyUnlockedProvince = nil
    }

    func clearExploredProvinces() {
        exploredProvinceNames.removeAll()
        newlyUnlockedProvince = nil

        UserDefaults.standard.removeObject(
            forKey: storageKey
        )
    }
}
