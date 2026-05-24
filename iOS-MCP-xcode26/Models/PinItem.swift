import Foundation
import CoreLocation

struct PinItem: Identifiable, Hashable {
    let id: String
    let name: String
    let category: PinCategory
    let coordinate: CLLocationCoordinate2D
    let thumbnailURL: URL?
    let rating: Double
    let distance: Double

    static func == (lhs: PinItem, rhs: PinItem) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

enum PinCategory: String, CaseIterable, Identifiable {
    case all = "All"
    case coffee = "Coffee"
    case food = "Food"
    case nature = "Nature"
    case art = "Art"
    case nightlife = "Nightlife"
    case shopping = "Shopping"
    case stay = "Stay"

    var id: String { rawValue }
}

extension PinItem {
    static let samplePins: [PinItem] = [
        PinItem(
            id: "1",
            name: "Blue Bottle Coffee",
            category: .coffee,
            coordinate: CLLocationCoordinate2D(latitude: 37.7858, longitude: -122.4014),
            thumbnailURL: nil,
            rating: 4.8,
            distance: 1.2
        ),
        PinItem(
            id: "2",
            name: "Tartine Bakery",
            category: .food,
            coordinate: CLLocationCoordinate2D(latitude: 37.7928, longitude: -122.4010),
            thumbnailURL: nil,
            rating: 4.6,
            distance: 0.9
        ),
        PinItem(
            id: "3",
            name: "SFMOMA",
            category: .art,
            coordinate: CLLocationCoordinate2D(latitude: 37.7857, longitude: -122.4011),
            thumbnailURL: nil,
            rating: 4.7,
            distance: 0.4
        ),
        PinItem(
            id: "4",
            name: "Ferry Building",
            category: .shopping,
            coordinate: CLLocationCoordinate2D(latitude: 37.7955, longitude: -122.3937),
            thumbnailURL: nil,
            rating: 4.6,
            distance: 0.7
        ),
        PinItem(
            id: "5",
            name: "Smitten Ice Cream",
            category: .food,
            coordinate: CLLocationCoordinate2D(latitude: 37.7756, longitude: -122.4194),
            thumbnailURL: nil,
            rating: 4.5,
            distance: 2.1
        ),
        PinItem(
            id: "6",
            name: "The Battery",
            category: .nightlife,
            coordinate: CLLocationCoordinate2D(latitude: 37.7880, longitude: -122.3990),
            thumbnailURL: nil,
            rating: 4.3,
            distance: 1.5
        ),
        PinItem(
            id: "7",
            name: "Golden Gate Park",
            category: .nature,
            coordinate: CLLocationCoordinate2D(latitude: 37.7694, longitude: -122.4862),
            thumbnailURL: nil,
            rating: 4.9,
            distance: 5.3
        ),
        PinItem(
            id: "8",
            name: "Twin Peaks",
            category: .nature,
            coordinate: CLLocationCoordinate2D(latitude: 37.7544, longitude: -122.4477),
            thumbnailURL: nil,
            rating: 4.7,
            distance: 4.1
        )
    ]
}
