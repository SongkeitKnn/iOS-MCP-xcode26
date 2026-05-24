import SwiftUI

struct PinRowView: View {
    let pin: PinItem
    let isSelected: Bool
    let thumbnailColors: [Color]

    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        colors: thumbnailColors,
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: 56, height: 56)

            VStack(alignment: .leading, spacing: 4) {
                Text(pin.name)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(Color.myPinPrimary)

                HStack(spacing: 6) {
                    Circle()
                        .fill(Color.myPinSecondary)
                        .frame(width: 6, height: 6)

                    Text(pin.category.rawValue)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(Color.myPinSecondary)

                    Text("\u{00B7}")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.myPinSecondary)

                    Text(String(format: "%.1f km", pin.distance))
                        .font(.system(size: 12))
                        .foregroundStyle(Color.myPinSecondary)

                    Text("\u{00B7}")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.myPinSecondary)

                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 12))
                            .foregroundStyle(.yellow)

                        Text(String(format: "%.1f", pin.rating))
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(Color.myPinPrimary)
                    }
                }
            }

            Spacer()

            Image(systemName: "chevron.forward")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(Color.myPinSecondary)
                .frame(width: 18, height: 18)
        }
        .padding(.horizontal, 16)
        .padding(.leading, 4)
        .padding(.vertical, 10)
        .background(isSelected ? Color.myPinBorder.opacity(0.3) : Color.clear)
    }
}

extension PinItem {
    var thumbnailGradient: [Color] {
        switch category {
        case .coffee:
            return [Color(hex: "D98C4D"), Color(hex: "734729")]
        case .food:
            return [Color(hex: "F2A84D"), Color(hex: "A65C1A")]
        case .art:
            return [Color(hex: "C775EB"), Color(hex: "5C2980")]
        case .nature:
            return [Color(hex: "66BB6A"), Color(hex: "2E7D32")]
        case .nightlife:
            return [Color(hex: "7E57C2"), Color(hex: "4527A0")]
        case .shopping:
            return [Color(hex: "42A5F5"), Color(hex: "1565C0")]
        case .stay:
            return [Color(hex: "EF5350"), Color(hex: "B71C1C")]
        case .all:
            return [Color(hex: "78909C"), Color(hex: "37474F")]
        }
    }
}
