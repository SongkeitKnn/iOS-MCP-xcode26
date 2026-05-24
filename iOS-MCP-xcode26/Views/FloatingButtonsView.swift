import SwiftUI

struct FloatingButtonsView: View {
    var onLocationTap: () -> Void
    var onAddPinTap: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Button(action: onLocationTap) {
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 56, height: 56)
                        .shadow(color: .black.opacity(0.18), radius: 6, x: 0, y: 3)

                    Image(systemName: "location.north.circle.fill")
                        .font(.system(size: 22))
                        .foregroundStyle(Color.myPinPrimary)
                }
            }
            .buttonStyle(.plain)

            Button(action: onAddPinTap) {
                ZStack {
                    Circle()
                        .fill(Color.myPinPrimary)
                        .frame(width: 56, height: 56)
                        .shadow(color: Color.myPinPrimary.opacity(0.4), radius: 20, x: 0, y: 8)

                    Image(systemName: "plus")
                        .font(.system(size: 28, weight: .medium))
                        .foregroundStyle(.white)
                }
            }
            .buttonStyle(.plain)
        }
    }
}
