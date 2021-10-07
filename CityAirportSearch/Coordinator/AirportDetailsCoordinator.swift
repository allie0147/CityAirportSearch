//
//  AirportDetailsCoordinator.swift
//  CityAirportSearch
//
//  Created by Allie Kim on 2021/10/08.
//

import Foundation

class AirportDetailsCoordinator: BaseCoordinator {

    private let router: Routing


    init(router: Routing) {
        self.router = router
    }

    override func start() {

        let view = AirportDetailsViewController.instantiate()

        router.present(view, isAnimated: true, onDismiss: isCompleted)
    }
}
