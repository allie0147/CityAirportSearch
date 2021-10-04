//
//  AirportCoordinator.swift
//  CityAirportSearch
//
//  Created by Allie Kim on 2021/09/26.
//

import UIKit

class AirportCoordinator: BaseCoordinator {

    private let navigationController: UINavigationController
    private let models: Set<AirportModel>

    init(models: Set<AirportModel>,
         navigation: UINavigationController) {
        self.navigationController = navigation
        self.models = models
    }

    override func start() {
        let view = AirportViewController.instantiate()
        let locationService = LocationService.shared

        view.viewModelBuilder = { [locationService, models] in
            let title = models.first?.city ?? ""
            return AirportsViewModel(
                input: $0,
                dependencies: (title: title,
                               models: models,
                               currentLocation: locationService.currentLocation )
            )
        }

        navigationController.pushViewController(view, animated: true)
    }
}