//
//  BaseCoordinator.swift
//  CityAirportSearch
//
//  Created by Allie Kim on 2021/09/18.
//

class BaseCoordinator: Coordinator {

    var childCoordinator: [Coordinator] = []

    func start() {
        fatalError("Child coordinator should implement 'start' function.")
    }
}
