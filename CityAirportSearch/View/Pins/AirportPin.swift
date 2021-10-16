//
//  AirportPin.swift
//  CityAirportSearch
//
//  Created by Allie Kim on 2021/10/16.
//

import UIKit
import MapKit

class AirportPin: NSObject, MKAnnotation {

    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D

    init(
        name: String,
        city: String = "",
        coordinate: CLLocationCoordinate2D
    ) {
        self.title = name
        self.subtitle = city
        self.coordinate = coordinate
    }
}
