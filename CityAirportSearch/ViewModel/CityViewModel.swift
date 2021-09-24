//
//  CityViewModel.swift
//  CityAirportSearch
//
//  Created by Allie Kim on 2021/09/24.
//

import Foundation

protocol CityViewPresentable {
    var city: String { get }
    var location: String { get }
}

/// tableview cell view model
struct CityViewModel: CityViewPresentable, Hashable {

    var city: String
    var location: String
}

extension CityViewModel {

    init(model: AirportModel) {
        self.city = model.city ?? ""
        self.location = "\(model.state ?? ""), \(model.country ?? "")"
    }
}
