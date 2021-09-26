//
//  AirportViewModel.swift
//  CityAirportSearch
//
//  Created by Allie Kim on 2021/09/26.
//

import Foundation

protocol AirportViewPresentable {

    typealias Output = ()

    typealias Input = ()

    var output: AirportViewPresentable.Output { get }
    var input: AirportViewPresentable.Input { get }
}

struct AirportViewModel: AirportViewPresentable {
    
    var output: AirportViewPresentable.Output
    var input: AirportViewPresentable.Input
    
}
