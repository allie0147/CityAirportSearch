//
//  AirportViewModel.swift
//  CityAirportSearch
//
//  Created by Allie Kim on 2021/09/27.
//

import Foundation

protocol AirportViewPresentable {
    var name: String { get }
    var code: String { get }
    var address: String { get } // country
    var distance: Double? { get }
    var formattedDistance: String { get }
    var runwayLength: String { get }
    var location: (lat: String, lon: String) { get }
}

struct AirportViewModel: AirportViewPresentable {

    var name: String

    var code: String

    var address: String

    var distance: Double?

    var formattedDistance: String {
        return "\(distance?.rounded(.toNearestOrEven) ?? 0 / 1000) Km"
    }

    var runwayLength: String

    var location: (lat: String, lon: String)
}

extension AirportViewModel {

    /// Accepting model and convert into viewModel
    init(usingModel model: AirportModel) {
        self.name = model.name
        self.code = model.code
        self.address = "\(model.state ?? ""), \(model.country ?? "NA")"
        self.runwayLength = "Runway Length: \(model.runwayLength ?? "NA")"
        self.location = (lat: model.lat, lon: model.lon)
        // MARK: FIXME - Distancing calculation from current location to airport
        self.distance = 0.0
    }
}
