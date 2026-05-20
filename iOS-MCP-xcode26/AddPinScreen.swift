import SwiftUI

enum PinPhase {
    case create
    case confirm
    case success
    case mismatch
}

struct AddPinScreen: View {
    @State private var pin = ""
    @State private var confirmedPin = ""
    @State private var phase: PinPhase = .create
    @State private var shakeOffset: CGFloat = 0

    private let pinLength = 4

    var body: some View {
        VStack(spacing: 40) {
            headerSection
            pinDotsSection
            keypadSection
        }
        .padding()
    }

    private var headerSection: some View {
        VStack(spacing: 8) {
            Image(systemName: phase == .success ? "checkmark.circle.fill" : "lock.shield.fill")
                .font(.system(size: 48))
                .foregroundStyle(phase == .success ? .green : .blue)

            Text(titleText)
                .font(.title2)
                .fontWeight(.semibold)

            Text(subtitleText)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private var pinDotsSection: some View {
        HStack(spacing: 20) {
            ForEach(0..<pinLength, id: \.self) { index in
                Circle()
                    .fill(index < pin.count ? Color.blue : Color.clear)
                    .stroke(Color.blue, lineWidth: 2)
                    .frame(width: 20, height: 20)
                    .animation(.easeInOut(duration: 0.15), value: pin.count)
            }
        }
        .offset(x: shakeOffset)
    }

    private var keypadSection: some View {
        VStack(spacing: 16) {
            ForEach(0..<3) { row in
                HStack(spacing: 24) {
                    ForEach(1...3, id: \.self) { col in
                        let digit = row * 3 + col
                        keypadButton(String(digit)) {
                            appendDigit(String(digit))
                        }
                    }
                }
            }
            HStack(spacing: 24) {
                Spacer().frame(width: 75, height: 75)

                keypadButton("0") {
                    appendDigit("0")
                }

                backButton
            }
        }
    }

    private func keypadButton(_ title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.title)
                .fontWeight(.medium)
                .frame(width: 75, height: 75)
                .background(Color(.systemGray6))
                .clipShape(Circle())
                .foregroundStyle(.primary)
        }
        .disabled(phase == .success)
    }

    private var backButton: some View {
        Button(action: removeLastDigit) {
            Image(systemName: "delete.left")
                .font(.title2)
                .frame(width: 75, height: 75)
                .background(Color(.systemGray6))
                .clipShape(Circle())
                .foregroundStyle(.primary)
        }
        .disabled(pin.isEmpty || phase == .success)
    }

    private var titleText: String {
        switch phase {
        case .create:
            return "Create a PIN"
        case .confirm:
            return "Confirm your PIN"
        case .success:
            return "PIN Created!"
        case .mismatch:
            return "PINs Don't Match"
        }
    }

    private var subtitleText: String {
        switch phase {
        case .create:
            return "Enter a \(pinLength)-digit PIN to secure your app"
        case .confirm:
            return "Re-enter your PIN to confirm"
        case .success:
            return "Your PIN has been set successfully"
        case .mismatch:
            return "Please try again"
        }
    }

    private func appendDigit(_ digit: String) {
        guard pin.count < pinLength else { return }
        pin += digit

        if pin.count == pinLength {
            handlePinComplete()
        }
    }

    private func removeLastDigit() {
        guard !pin.isEmpty else { return }
        pin.removeLast()
    }

    private func handlePinComplete() {
        switch phase {
        case .create:
            confirmedPin = pin
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                pin = ""
                phase = .confirm
            }
        case .confirm:
            if pin == confirmedPin {
                phase = .success
            } else {
                phase = .mismatch
                triggerShake()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    pin = ""
                    confirmedPin = ""
                    phase = .create
                }
            }
        default:
            break
        }
    }

    private func triggerShake() {
        withAnimation(.default) {
            shakeOffset = -10
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.default) {
                shakeOffset = 10
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.default) {
                shakeOffset = -5
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.default) {
                shakeOffset = 5
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation(.default) {
                shakeOffset = 0
            }
        }
    }
}

#Preview {
    AddPinScreen()
}
