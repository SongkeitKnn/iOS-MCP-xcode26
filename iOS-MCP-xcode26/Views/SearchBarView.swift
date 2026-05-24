import SwiftUI

struct SearchBarView: View {
    let userInitial: String

    var body: some View {
        HStack(spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 16))
                    .foregroundStyle(Color.myPinPlaceholder)

                Text("Search this area\u{2026}")
                    .font(.custom("SF Pro", size: 15))
                    .foregroundStyle(Color.myPinPlaceholder)

                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.white)
            .clipShape(Capsule())
            .shadow(color: .black.opacity(0.1), radius: 12, x: 0, y: 4)

            ZStack {
                Circle()
                    .fill(Color.myPinPrimary)
                    .frame(width: 40, height: 40)

                Text(userInitial)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
            }
        }
        .padding(.horizontal, 16)
    }
}
