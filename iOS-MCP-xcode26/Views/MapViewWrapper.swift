import SwiftUI
import MapLibre

struct MapViewWrapper: UIViewRepresentable {
    @ObservedObject var coordinator: MapCoordinator

    func makeUIView(context: Context) -> MLNMapView {
        let mapView = MLNMapView(frame: .zero)
        mapView.styleURL = URL(string: "https://demotiles.maplibre.org/style.json")
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .none
        mapView.zoomLevel = 13
        mapView.centerCoordinate = CLLocationCoordinate2D(latitude: 37.7858, longitude: -122.4014)
        mapView.logoView.isHidden = true
        mapView.attributionButton.isHidden = true
        mapView.showsCompass = false

        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleMapTap(_:)))
        mapView.addGestureRecognizer(tapGesture)

        context.coordinator.mapView = mapView
        return mapView
    }

    func updateUIView(_ mapView: MLNMapView, context: Context) {
        if let pins = coordinator.pinsToUpdate {
            coordinator.pinsToUpdate = nil
            coordinator.updatePinsOnMap(pins, mapView: mapView)
        }
        if coordinator.shouldRecenter {
            coordinator.shouldRecenter = false
            if let userLocation = mapView.userLocation?.coordinate {
                let camera = MLNMapCamera(lookingAtCenter: userLocation, altitude: 4500, pitch: 0, heading: 0)
                mapView.fly(to: camera, completionHandler: nil)
            }
        }
        if coordinator.shouldFitPins {
            coordinator.shouldFitPins = false
            coordinator.fitAllPins(mapView: mapView)
        }
    }

    func makeCoordinator() -> Coordinator {
        coordinator
    }

    class Coordinator: NSObject, MLNMapViewDelegate, ObservableObject {
        weak var mapView: MLNMapView?
        @Published var pinsToUpdate: [PinItem]?
        @Published var shouldRecenter = false
        @Published var shouldFitPins = false
        var onPinTap: ((PinItem) -> Void)?
        var currentPins: [PinItem] = []

        func updatePinsOnMap(_ pins: [PinItem], mapView: MLNMapView) {
            currentPins = pins
            guard let style = mapView.style else { return }

            if let existingSource = style.source(withIdentifier: "pins-source") as? MLNShapeSource {
                let features = pins.map { pin -> MLNPointFeature in
                    let feature = MLNPointFeature()
                    feature.coordinate = pin.coordinate
                    feature.attributes = [
                        "id": pin.id,
                        "name": pin.name,
                        "category": pin.category.rawValue,
                        "rating": pin.rating
                    ]
                    return feature
                }
                existingSource.shape = MLNShapeCollectionFeature(features: features)
            } else {
                let features = pins.map { pin -> MLNPointFeature in
                    let feature = MLNPointFeature()
                    feature.coordinate = pin.coordinate
                    feature.attributes = [
                        "id": pin.id,
                        "name": pin.name,
                        "category": pin.category.rawValue,
                        "rating": pin.rating
                    ]
                    return feature
                }
                let source = MLNShapeSource(
                    identifier: "pins-source",
                    features: MLNShapeCollectionFeature(features: features),
                    options: [
                        .clustered: true,
                        .clusterRadius: 50,
                        .maximumZoomLevelForClustering: 14
                    ]
                )
                style.addSource(source)

                let clusterSource = MLNShapeSource(identifier: "cluster-source", features: [], options: nil)
                style.addSource(clusterSource)

                let defaultPinImage = createCircularPinImage(size: 34, border: 2)
                style.setImage(defaultPinImage, forName: "pin-marker")

                let selectedPinImage = createCircularPinImage(size: 48, border: 2)
                style.setImage(selectedPinImage, forName: "pin-marker-selected")

                let clusterImage = createClusterImage(size: 40)
                style.setImage(clusterImage, forName: "cluster-marker")

                let symbolLayer = MLNSymbolStyleLayer(identifier: "pins-layer", source: source)
                symbolLayer.iconImageName = NSExpression(forConstantValue: "pin-marker")
                symbolLayer.iconAllowsOverlap = NSExpression(forConstantValue: true)
                symbolLayer.iconAnchor = NSExpression(forConstantValue: "bottom")
                symbolLayer.iconOffset = NSExpression(forConstantValue: NSValue(cgSize: CGSize(width: 0, height: -17)))
                style.addLayer(symbolLayer)

                let clusterLayer = MLNCircleStyleLayer(identifier: "cluster-layer", source: source)
                let shouldCluster = NSExpression(format: "point_count != NIL")
                clusterLayer.circleOpacity = NSExpression(forConditional: shouldCluster, trueExpression: NSExpression(forConstantValue: 1), falseExpression: NSExpression(forConstantValue: 0))
                clusterLayer.circleRadius = NSExpression(forConstantValue: 20)
                clusterLayer.circleColor = NSExpression(forConstantValue: UIColor(Color.myPinPrimary))
                clusterLayer.circleStrokeColor = NSExpression(forConstantValue: UIColor.white)
                clusterLayer.circleStrokeWidth = NSExpression(forConstantValue: 3)
                style.addLayer(clusterLayer)

                let clusterCountLayer = MLNSymbolStyleLayer(identifier: "cluster-count-layer", source: source)
                clusterCountLayer.text = NSExpression(format: "point_count != NIL ? CONCATENATE('+', CAST(point_count, 'NSString')) : ''")
                clusterCountLayer.textColor = NSExpression(forConstantValue: UIColor.white)
                clusterCountLayer.textFontSize = NSExpression(forConstantValue: 13)
                clusterCountLayer.textFontNames = NSExpression(forConstantValue: ["InstrumentSans-Bold"])
                clusterCountLayer.textAllowsOverlap = NSExpression(forConstantValue: true)
                style.addLayer(clusterCountLayer)
            }
        }

        func fitAllPins(mapView: MLNMapView) {
            let pins = currentPins
            if pins.isEmpty { return }
            if pins.count == 1 {
                mapView.setCenter(pins[0].coordinate, zoomLevel: 15, animated: true)
                return
            }
            let lats = pins.map { $0.coordinate.latitude }
            let lons = pins.map { $0.coordinate.longitude }
            let bounds = MLNCoordinateBounds(
                sw: CLLocationCoordinate2D(latitude: lats.min()!, longitude: lons.min()!),
                ne: CLLocationCoordinate2D(latitude: lats.max()!, longitude: lons.max()!)
            )
            mapView.setVisibleCoordinateBounds(bounds, edgePadding: UIEdgeInsets(top: 200, left: 64, bottom: 350, right: 64), animated: true)
        }

        @objc func handleMapTap(_ gesture: UITapGestureRecognizer) {
            guard let mapView = mapView else { return }
            let point = gesture.location(in: mapView)
            let features = mapView.visibleFeatures(at: point, styleLayerIdentifiers: Set(["pins-layer"]))
            if let feature = features.first,
               let pinId = feature.attribute(forKey: "id") as? String,
               let pin = currentPins.first(where: { $0.id == pinId }) {
                onPinTap?(pin)
            }
        }

        private func createCircularPinImage(size: CGFloat, border: CGFloat) -> UIImage {
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: size, height: size))
            return renderer.image { ctx in
                let rect = CGRect(x: 0, y: 0, width: size, height: size)
                let borderPath = UIBezierPath(ovalIn: rect)
                UIColor.white.setFill()
                borderPath.fill()

                let innerRect = rect.insetBy(dx: border, dy: border)
                let innerPath = UIBezierPath(ovalIn: innerRect)
                UIColor.systemGray4.setFill()
                innerPath.fill()

                let config = UIImage.SymbolConfiguration(pointSize: size * 0.35, weight: .regular)
                if let icon = UIImage(systemName: "mappin.and.circle", withConfiguration: config) {
                    let iconRect = CGRect(
                        x: innerRect.midX - icon.size.width / 2,
                        y: innerRect.midY - icon.size.height / 2,
                        width: icon.size.width,
                        height: icon.size.height
                    )
                    UIColor.myPinSecondary.setFill()
                    icon.draw(in: iconRect)
                }
            }
        }

        private func createClusterImage(size: CGFloat) -> UIImage {
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: size, height: size))
            return renderer.image { ctx in
                let rect = CGRect(x: 0, y: 0, width: size, height: size)
                UIColor(Color.myPinPrimary).setFill()
                UIBezierPath(ovalIn: rect).fill()
            }
        }

        func mapView(_ mapView: MLNMapView, didFinishLoading style: MLNStyle) {
            if !currentPins.isEmpty {
                updatePinsOnMap(currentPins, mapView: mapView)
            }
        }
    }
}
