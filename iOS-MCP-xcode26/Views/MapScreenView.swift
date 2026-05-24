import SwiftUI
import CoreLocation

struct MapScreenView: View {
    @State private var selectedCategory: PinCategory = .all
    @State private var selectedPinId: String?
    @State private var selectedTab: TabBarView.TabItem = .map
    @StateObject private var mapCoordinator = MapViewWrapper.Coordinator()
    @State private var filteredPins: [PinItem] = PinItem.samplePins
    @State private var locationManager = CLLocationManager()
    @State private var showLocationDenied = false

    var body: some View {
        ZStack {
            mapViewLayer

            VStack(spacing: 0) {
                Spacer().frame(height: 56)
                SearchBarView(userInitial: "A")
                Spacer().frame(height: 16)
                CategoryChipsView(selectedCategory: $selectedCategory)
                    .onChange(of: selectedCategory) { _, newCategory in
                        filterPins(for: newCategory)
                    }
                Spacer()
            }

            floatingButtons

            bottomSheet

            VStack {
                Spacer()
                TabBarView(selectedTab: $selectedTab)
            }
        }
        .background(Color.white)
        .ignoresSafeArea()
        .onAppear {
            requestLocationPermission()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                mapCoordinator.pinsToUpdate = filteredPins
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    mapCoordinator.shouldFitPins = true
                }
            }
        }
        .alert("Location Access Denied", isPresented: $showLocationDenied) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Please enable location access in Settings to see your current position on the map.")
        }
    }

    private var mapViewLayer: some View {
        MapViewWrapper(coordinator: mapCoordinator)
            .ignoresSafeArea()
            .onAppear {
                mapCoordinator.onPinTap = { pin in
                    selectedPinId = pin.id
                }
            }
    }

    private var floatingButtons: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                FloatingButtonsView(
                    onLocationTap: {
                        let status = locationManager.authorizationStatus
                        if status == .denied {
                            showLocationDenied = true
                        } else {
                            mapCoordinator.shouldRecenter = true
                        }
                    },
                    onAddPinTap: {
                        selectedTab = .add
                    }
                )
                .padding(.trailing, 18)
                .padding(.bottom, 360)
            }
        }
    }

    private var bottomSheet: some View {
        VStack {
            Spacer()
            BottomSheetView(
                pins: filteredPins,
                selectedPinId: $selectedPinId,
                sheetHeight: .constant(340),
                isDragging: false
            )
            .frame(height: 340)
        }
    }

    private func filterPins(for category: PinCategory) {
        if category == .all {
            filteredPins = PinItem.samplePins
        } else {
            filteredPins = PinItem.samplePins.filter { $0.category == category }
        }
        selectedPinId = nil
        mapCoordinator.pinsToUpdate = filteredPins
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            mapCoordinator.shouldFitPins = true
        }
    }

    private func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
}
