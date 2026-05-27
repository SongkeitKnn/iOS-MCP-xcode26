import SwiftUI

struct AddPinView: View {
    @State private var placeName = ""
    @State private var selectedCategory: String? = nil
    @State private var rating = 0
    @State private var notes = ""
    @State private var showDiscardAlert = false
    @State private var showPhotoPicker = false
    @Environment(\.dismiss) private var dismiss

    private let categories = ["Food", "Coffee", "Nature", "Art", "Nightlife", "Shopping"]

    private var hasUnsavedChanges: Bool {
        !placeName.isEmpty || selectedCategory != nil || rating > 0 || !notes.isEmpty
    }

    private var canSave: Bool {
        !placeName.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        VStack(spacing: 0) {
            topNavBar
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    fieldLabel("LOCATION")
                        .padding(.top, 16)
                    locationCard
                        .padding(.top, 7)

                    fieldLabel("PLACE NAME")
                        .padding(.top, 20)
                    placeNameField
                        .padding(.top, 7)

                    fieldLabel("CATEGORY")
                        .padding(.top, 18)
                    categoryChipsRow
                        .padding(.top, 7)

                    fieldLabel("YOUR RATING")
                        .padding(.top, 20)
                    starRatingRow
                        .padding(.top, 7)

                    fieldLabel("NOTES")
                        .padding(.top, 24)
                    notesField
                        .padding(.top, 7)

                    fieldLabel("PHOTOS")
                        .padding(.top, 16)
                    photoRow
                        .padding(.top, 7)

                    Spacer(minLength: 16)
                }
                .padding(.horizontal, 20)
            }
            bottomSaveBar
            tabBar
        }
        .background(Color.white)
        .alert("Discard Changes?", isPresented: $showDiscardAlert) {
            Button("Discard", role: .destructive) { dismiss() }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("You have unsaved changes. Are you sure you want to discard them?")
        }
    }

    private var topNavBar: some View {
        VStack(spacing: 0) {
            Spacer()
            HStack {
                Button {
                    if hasUnsavedChanges {
                        showDiscardAlert = true
                    } else {
                        dismiss()
                    }
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Color(red: 33/255, green: 37/255, blue: 41/255))
                        .frame(width: 40, height: 40)
                        .background(Color(red: 245/255, green: 246/255, blue: 247/255))
                        .clipShape(Circle())
                }
                Spacer()
                Text("Add Pin")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(Color(red: 33/255, green: 37/255, blue: 41/255))
                Spacer()
                Button {
                    savePin()
                } label: {
                    Text("Save")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(Color(red: 33/255, green: 37/255, blue: 41/255))
                }
                .frame(width: 60)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 12)
        }
        .frame(height: 100)
        .overlay(
            Rectangle()
                .fill(Color(red: 230/255, green: 232/255, blue: 235/255))
                .frame(height: 1),
            alignment: .bottom
        )
    }

    private func fieldLabel(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 12, weight: .semibold))
            .foregroundStyle(Color(red: 107/255, green: 114/255, blue: 128/255))
    }

    private var locationCard: some View {
        Button {} label: {
            HStack(spacing: 0) {
                ZStack {
                    RoundedRectangle(cornerRadius: 0)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 212/255, green: 227/255, blue: 242/255),
                                    Color(red: 168/255, green: 194/255, blue: 219/255)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 96, height: 96)
                        .clipShape(UnevenRoundedRectangle(topLeadingRadius: 16, bottomLeadingRadius: 16))

                    Image(systemName: "mappin.and.ellipse")
                        .font(.system(size: 18))
                        .foregroundStyle(Color(red: 33/255, green: 37/255, blue: 41/255))
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Current location")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(Color(red: 33/255, green: 37/255, blue: 41/255))
                    Text("Tap to drop a pin on map")
                        .font(.system(size: 13, weight: .regular))
                        .foregroundStyle(Color(red: 107/255, green: 114/255, blue: 128/255))
                }
                .padding(.leading, 16)

                Spacer()
            }
            .frame(maxWidth: .infinity)
            .frame(height: 96)
            .background(Color(red: 245/255, green: 246/255, blue: 247/255))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color(red: 230/255, green: 232/255, blue: 235/255), lineWidth: 1)
            )
        }
    }

    private var placeNameField: some View {
        TextField("Enter place name", text: $placeName)
            .font(.system(size: 15, weight: .regular))
            .foregroundStyle(Color(red: 33/255, green: 37/255, blue: 41/255))
            .padding(.horizontal, 16)
            .frame(height: 52)
            .background(Color(red: 245/255, green: 246/255, blue: 247/255))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color(red: 230/255, green: 232/255, blue: 235/255), lineWidth: 1)
            )
    }

    private var categoryChipsRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(categories, id: \.self) { category in
                    let isSelected = selectedCategory == category
                    Button {
                        withAnimation(.easeInOut(duration: 0.15)) {
                            selectedCategory = isSelected ? nil : category
                        }
                    } label: {
                        Text(category)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(isSelected ? .white : Color(red: 33/255, green: 37/255, blue: 41/255))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(
                                isSelected
                                    ? Color(red: 33/255, green: 37/255, blue: 41/255)
                                    : Color(red: 245/255, green: 246/255, blue: 247/255)
                            )
                            .clipShape(Capsule())
                            .overlay(
                                Capsule()
                                    .stroke(
                                        isSelected
                                            ? Color.clear
                                            : Color(red: 230/255, green: 232/255, blue: 235/255),
                                        lineWidth: 1
                                    )
                            )
                    }
                }
            }
        }
    }

    private var starRatingRow: some View {
        HStack(spacing: 10) {
            ForEach(1...5, id: \.self) { star in
                Button {
                    withAnimation(.easeInOut(duration: 0.15)) {
                        rating = (rating == star) ? 0 : star
                    }
                } label: {
                    Image(systemName: star <= rating ? "star.fill" : "star")
                        .font(.system(size: 18))
                        .foregroundStyle(
                            star <= rating
                                ? Color(red: 33/255, green: 37/255, blue: 41/255)
                                : Color(red: 107/255, green: 114/255, blue: 128/255)
                        )
                        .frame(width: 28, height: 28)
                }
            }
        }
    }

    private var notesField: some View {
        ZStack(alignment: .topLeading) {
            if notes.isEmpty {
                Text("What made this place special? (vibe, must-order, hours\u{2026})")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(Color(red: 107/255, green: 114/255, blue: 128/255))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
            }
            TextEditor(text: $notes)
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(Color(red: 33/255, green: 37/255, blue: 41/255))
                .scrollContentBackground(.hidden)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
        }
        .frame(height: 96)
        .background(Color(red: 245/255, green: 246/255, blue: 247/255))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color(red: 230/255, green: 232/255, blue: 235/255), lineWidth: 1)
        )
    }

    private var photoRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                Button {
                    showPhotoPicker = true
                } label: {
                    VStack(spacing: 0) {
                        Image(systemName: "plus")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(Color(red: 107/255, green: 114/255, blue: 128/255))
                    }
                    .frame(width: 76, height: 76)
                    .background(Color(red: 245/255, green: 246/255, blue: 247/255))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(
                                style: StrokeStyle(lineWidth: 1, dash: [6, 4])
                            )
                            .foregroundStyle(Color(red: 230/255, green: 232/255, blue: 235/255))
                    )
                }

                ForEach(0..<3, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            LinearGradient(
                                colors: sampleColors(for: index),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: 76, height: 76)
                        .overlay(
                            Image(systemName: "photo")
                                .font(.system(size: 20))
                                .foregroundStyle(.white.opacity(0.8))
                        )
                }
            }
        }
    }

    private func sampleColors(for index: Int) -> [Color] {
        switch index {
        case 0:
            return [
                Color(red: 217/255, green: 140/255, blue: 77/255),
                Color(red: 115/255, green: 71/255, blue: 41/255)
            ]
        case 1:
            return [
                Color(red: 128/255, green: 168/255, blue: 199/255),
                Color(red: 51/255, green: 82/255, blue: 122/255)
            ]
        case 2:
            return [
                Color(red: 158/255, green: 189/255, blue: 128/255),
                Color(red: 66/255, green: 97/255, blue: 51/255)
            ]
        default:
            return [.gray]
        }
    }

    private var bottomSaveBar: some View {
        VStack(spacing: 0) {
            Button {
                savePin()
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "bookmark.fill")
                        .font(.system(size: 14))
                    Text("Save Pin")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(
                    canSave
                        ? Color(red: 33/255, green: 37/255, blue: 41/255)
                        : Color(red: 33/255, green: 37/255, blue: 41/255).opacity(0.4)
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(
                    color: Color(red: 33/255, green: 37/255, blue: 41/255).opacity(0.35),
                    radius: 8, y: 4
                )
            }
            .disabled(!canSave)
            .padding(.horizontal, 20)
            .padding(.top, 14)
            Spacer()
        }
        .frame(height: 100)
        .background(Color.white)
        .overlay(
            Rectangle()
                .fill(Color(red: 230/255, green: 232/255, blue: 235/255))
                .frame(height: 1),
            alignment: .top
        )
    }

    private var tabBar: some View {
        HStack {
            tabItem(icon: "mappin.and.ellipse", label: "Map", isActive: false)
            tabItem(icon: "bookmark", label: "My Pins", isActive: false)
            tabItem(icon: "plus.circle.fill", label: "Add", isActive: true)
            tabItem(icon: "person.fill", label: "Profile", isActive: false)
        }
        .padding(.horizontal, 24)
        .padding(.top, 10)
        .padding(.bottom, 18)
        .background(Color.white)
        .overlay(
            Rectangle()
                .fill(Color(red: 230/255, green: 232/255, blue: 235/255))
                .frame(height: 1),
            alignment: .top
        )
    }

    private func tabItem(icon: String, label: String, isActive: Bool) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .frame(width: 22, height: 22)
            Text(label)
                .font(.system(size: 11, weight: .medium))
        }
        .foregroundStyle(
            isActive
                ? Color(red: 33/255, green: 37/255, blue: 41/255)
                : Color(red: 107/255, green: 114/255, blue: 128/255)
        )
        .frame(maxWidth: .infinity)
    }

    private func savePin() {
        guard canSave else { return }
        dismiss()
    }
}

#Preview {
    AddPinView()
}
