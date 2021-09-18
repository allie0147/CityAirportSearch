//
//  BaseCoordinator.swift
//  CityAirportSearch
//
//  Created by Allie Kim on 2021/09/18.
//

import Foundation

class BaseCoordinator: Coordinator {

    var childCoordinator: [Coordinator] = []

    func start() {
        fatalError("Child coordinator should implement 'start' function.")
    }
}
