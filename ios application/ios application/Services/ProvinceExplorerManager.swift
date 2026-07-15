import Foundation
import Combine

final class ProvinceExplorerManager: ObservableObject {

    static let shared = ProvinceExplorerManager()

    @Published private(set) var discoveredProvinces:Set<SriLankaProvince> = []

    private let storageKey = "discoveredProvinces"

    private init() {
        loadDiscoveredProvinces()
    }

    func discover(_ province: SriLankaProvince) -> Bool {
        guard !discoveredProvinces.contains(province) else {
            return false
        }

        discoveredProvinces.insert(province)
        saveDiscoveredProvinces()

        return true
    }

    func isDiscovered(_ province: SriLankaProvince) -> Bool {
        discoveredProvinces.contains(province)
    }

    var exploredCount: Int {
        discoveredProvinces.count
    }

    var progress: Double {
        Double(exploredCount) /
        Double(SriLankaProvince.allCases.count)
    }

    private func saveDiscoveredProvinces() {
        let values = discoveredProvinces.map(\.rawValue)

        UserDefaults.standard.set(
            values,
            forKey: storageKey
        )
    }

    private func loadDiscoveredProvinces() {
        let savedValues = UserDefaults.standard.stringArray(
            forKey: storageKey
        ) ?? []

        discoveredProvinces = Set(
            savedValues.compactMap {
                SriLankaProvince(rawValue: $0)
            }
        )
    }
}
