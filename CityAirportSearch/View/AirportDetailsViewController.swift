//
//  AirportDetailsViewController.swift
//  CityAirportSearch
//
//  Created by Allie Kim on 2021/10/07.
//

import UIKit
import MapKit

class AirportDetailsViewController: UIViewController, Storyboardable {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var airportNameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var runwayLengthLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }


}
