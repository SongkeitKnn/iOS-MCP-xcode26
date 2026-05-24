import SwiftUI

struct BottomSheetView: View {
    let pins: [PinItem]
    @Binding var selectedPinId: String?
    @Binding var sheetHeight: CGFloat
    let isDragging: Bool

    private let minSheetHeight: CGFloat = 120
    private let midSheetHeight: CGFloat = 340
    private let maxSheetHeight: CGFloat = 550

    var body: some View {
        VStack(spacing: 0) {
            Capsule()
                .fill(Color.myPinDragHandle)
                .frame(width: 40, height: 4)
                .padding(.top, 10)
                .padding(.bottom, 14)

            HStack(alignment: .firstTextBaseline) {
                Text("Nearby Pins")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(Color.myPinPrimary)

                Text("\(pins.count) places")
                    .font(.system(size: 13))
                    .foregroundStyle(Color.myPinSecondary)

                Spacer()

                HStack(spacing: 4) {
                    Text("Nearest")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(Color.myPinPrimary)

                    Image(systemName: "ellipsis")
                        .font(.system(size: 14))
                        .foregroundStyle(Color.myPinPrimary)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.myPinSortBg)
                .clipShape(Capsule())
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 10)

            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
                        ForEach(Array(pins.enumerated()), id: \.element.id) { index, pin in
                            PinRowView(
                                pin: pin,
                                isSelected: selectedPinId == pin.id,
                                thumbnailColors: pin.thumbnailGradient
                            )
                            .id(pin.id)

                            if index < pins.count - 1 {
                                Rectangle()
                                    .fill(Color.myPinDivider)
                                    .frame(height: 1)
                                    .padding(.horizontal, 20)
                            }
                        }
                    }
                }
                .onChange(of: selectedPinId) { _, newId in
                    if let id = newId {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            proxy.scrollTo(id, anchor: .center)
                        }
                    }
                }
            }
        }
        .background(Color.white)
        .clipShape(
            UnevenRoundedRectangle(topLeadingRadius: 28, topTrailingRadius: 28)
        )
        .shadow(color: .black.opacity(0.12), radius: 24, x: 0, y: -6)
    }
}
