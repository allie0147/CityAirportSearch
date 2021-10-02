//
//  LocationService.swift
//  CityAirportSearch
//
//  Created by Allie Kim on 2021/10/02.
//

import Foundation
import CoreLocation
import RxSwift
import RxRelay

/// CoreLocation Service
final class LocationService: NSObject {

    static let shared = LocationService()

    private let manager = CLLocationManager()

    private let currentLoationRelay: BehaviorRelay<(lat: Double, lon: Double)?> = BehaviorRelay(value: nil)

    lazy var currentLocation: Observable<(lat: Double, lon: Double)?>
        = self.currentLoationRelay
        .asObservable()
        .share(replay: 1, scope: .forever)

    private override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        manager.requestAlwaysAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            manager.startUpdatingLocation()
        }
    }

    deinit {
        manager.stopUpdatingLocation()
    }
}


// MARK: -Extension: CLLocationManagerDelegate
extension LocationService: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {

        if let location = locations.last {
            let currentLocation = (
                lat: location.coordinate.latitude,
                lon: location.coordinate.longitude
            )
            currentLoationRelay.accept(currentLocation)
        }
        manager.stopUpdatingLocation()
    }
}
