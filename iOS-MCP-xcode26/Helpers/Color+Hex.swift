import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

extension Color {
    static let myPinPrimary = Color(hex: "212529")
    static let myPinSecondary = Color(hex: "6B7280")
    static let myPinPlaceholder = Color(hex: "808799")
    static let myPinBorder = Color(hex: "E6E8EB")
    static let myPinBackground = Color(hex: "FFFFFF")
    static let myPinChipSelected = Color(hex: "212529")
    static let myPinChipUnselected = Color(hex: "FFFFFF")
    static let myPinDragHandle = Color(hex: "CCD4E0")
    static let myPinSortBg = Color(hex: "F5F6F7")
    static let myPinDivider = Color(hex: "E6E8EB")
}
