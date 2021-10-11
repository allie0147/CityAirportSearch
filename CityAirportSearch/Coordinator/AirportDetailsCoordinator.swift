//
//  AirportDetailsCoordinator.swift
//  CityAirportSearch
//
//  Created by Allie Kim on 2021/10/08.
//

import Foundation

class AirportDetailsCoordinator: BaseCoordinator {

    private let router: Routing
    private let model: AirportModel


    init(model: AirportModel, router: Routing) {
        self.model = model
        self.router = router
    }

    override func start() {

        let view = AirportDetailsViewController.instantiate()

        let locationService = LocationService.shared

        // reference of viewModel
        view.viewModelBuilder = { [model, locationService] in
            AirportDetailsViewModel(
                input: $0,
                dependencies: (
                    model: model,
                    currentLocation: locationService.currentLocation
                )
            )
        }

        router.present(view, isAnimated: true, onDismiss: isCompleted)
    }
}
