//
//  AirportAPI.swift
//  CityAirportSearch
//
//  Created by Allie Kim on 2021/09/18.
//

import RxSwift

/// API Interface
protocol AirportAPI {
    func fetchAirports() -> Single<AirportsResponse>
}
