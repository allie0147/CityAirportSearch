//
//  AirportDetailsViewController.swift
//  CityAirportSearch
//
//  Created by Allie Kim on 2021/10/07.
//

import UIKit
import MapKit
import RxSwift

class AirportDetailsViewController: UIViewController, Storyboardable {

    // MARK: -UI
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var airportNameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var runwayLengthLabel: UILabel!

    private var viewModel: AirportDetailsViewPresentable!
    var viewModelBuilder: AirportDetailsViewPresentable.ViewModelBuilder!

    private let bag = DisposeBag()


    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewModel = viewModelBuilder(())
        self.setupBinding()
        self.mapView.delegate = self
    }
}

private extension AirportDetailsViewController {

    func setupUI(viewModel: AirportViewPresentable) {
        self.airportNameLabel.text = viewModel.name
        self.distanceLabel.text = viewModel.formattedDistance
        self.countryLabel.text = viewModel.address
        self.runwayLengthLabel.text = viewModel.runwayLength

        self.closeButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        self.closeButton.layer.cornerRadius = self.closeButton.bounds.size.width / 2
        self.closeButton.clipsToBounds = true
    }

    func setupBinding() {

        self.viewModel.output.airportDetails
            .map { [weak self] viewModel in
            self?.setupUI(viewModel: viewModel)
        }
            .drive()
            .disposed(by: bag)

        self.viewModel.output.mapDetails
            .map { [weak self] viewModel in
            self?.setupMapUI(viewModel: viewModel)
        }
            .drive()
            .disposed(by: bag)
    }

    func setupMapUI(viewModel: AirportMapViewPresentable) {

        let currentPoint = CLLocationCoordinate2D(latitude: viewModel.currentLocation.lat,
                                                  longitude: viewModel.currentLocation.lon)

        let airportPoint = CLLocationCoordinate2D(latitude: viewModel.airportLocation.lat,
                                                  longitude: viewModel.airportLocation.lon)

        // Pins
        let currentPin = AirportPin(name: "Current",
                                    coordinate: currentPoint)
        let airportPin = AirportPin(name: viewModel.airport.name,
                                    city: viewModel.airport.city,
                                    coordinate: airportPoint)

        mapView.addAnnotations([currentPin, airportPin])

        // Placemarks
        let currentPlacemark = MKPlacemark(coordinate: currentPoint)
        let destinationPlacemark = MKPlacemark(coordinate: airportPoint)

        let directionRequest = MKDirections.Request()

        directionRequest.source = MKMapItem(placemark: currentPlacemark)
        directionRequest.destination = MKMapItem(placemark: destinationPlacemark)

        // Transportation Type
        directionRequest.transportType = .automobile

        // Calculate directions and show route
        let directions = MKDirections(request: directionRequest)

        directions.calculate { [weak self] response, error in

            if let error = error {
                print(error.localizedDescription)
                return
            }

            guard let route = response?.routes.first else {
                return
            }

            self?.mapView.addOverlay(route.polyline, level: .aboveRoads)

            // Add animation
            UIView.animate(withDuration: 1.5) { [weak self] in
                let mapRect = route.polyline.boundingMapRect
                let region = MKCoordinateRegion(mapRect)
                self?.mapView.setRegion(region, animated: true)
            }
        }
    }

    @objc
    func dismissView(_ sender: UIButton) {
        if sender == closeButton {
            self.dismiss(animated: true)
        }
    }
}

// MARK: - MKMapViewDelegate
extension AirportDetailsViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {

        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .reddishPink
        renderer.lineWidth = 2.0
        return renderer
    }
}
