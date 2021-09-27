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
    var distance: Double { get }
    var formattedDistance: String { get }
}

//struct AirportViewModel: AirportViewPresentable {
//
//}
