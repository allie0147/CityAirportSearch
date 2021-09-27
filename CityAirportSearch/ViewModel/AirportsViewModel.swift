//
//  AirportViewModel.swift
//  CityAirportSearch
//
//  Created by Allie Kim on 2021/09/26.
//

import Foundation

protocol AirportsViewPresentable {

    typealias Output = ()

    typealias Input = ()

    var output: AirportsViewPresentable.Output { get }
    var input: AirportsViewPresentable.Input { get }
}

struct AirportsViewModel: AirportsViewPresentable {

    var output: AirportsViewPresentable.Output
    var input: AirportsViewPresentable.Input

}
