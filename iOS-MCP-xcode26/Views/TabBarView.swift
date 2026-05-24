import SwiftUI

struct TabBarView: View {
    @Binding var selectedTab: TabItem

    enum TabItem: String, CaseIterable {
        case map = "Map"
        case myPins = "My Pins"
        case add = "Add"
        case profile = "Profile"
    }

    var body: some View {
        HStack {
            tabButton(tab: .map, icon: "location.fill", label: "Map")
            tabButton(tab: .myPins, icon: "bookmark", label: "My Pins")
            tabButton(tab: .add, icon: "plus.circle.fill", label: "Add")
            tabButton(tab: .profile, icon: "person.fill", label: "Profile")
        }
        .padding(.horizontal, 24)
        .padding(.top, 10)
        .padding(.bottom, 18)
        .background(Color.white)
        .overlay(
            Rectangle()
                .fill(Color.myPinBorder)
                .frame(height: 1),
            alignment: .top
        )
    }

    private func tabButton(tab: TabItem, icon: String, label: String) -> some View {
        Button {
            selectedTab = tab
        } label: {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 22))

                Text(label)
                    .font(.system(size: 11, weight: .medium))
            }
            .foregroundStyle(selectedTab == tab ? Color.myPinPrimary : Color.myPinSecondary)
        }
        .frame(maxWidth: .infinity)
        .buttonStyle(.plain)
    }
}
