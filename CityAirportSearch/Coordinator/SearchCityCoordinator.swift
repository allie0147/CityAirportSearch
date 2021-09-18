//
//  SearchCityCoordinator.swift
//  CityAirportSearch
//
//  Created by Allie Kim on 2021/09/18.
//

import UIKit

class SearchCityCoordinator: BaseCoordinator {
    private let navigationController: UINavigationController

    init(navigation: UINavigationController) {
        self.navigationController = navigation
    }

    override func start() {
        let view = SearchCityViewController.instantiate()
        let service = AirportService.shared

        view.viewModelBuilder = {
            SearchCityViewModel(input: $0, airportService: service)
        }

        navigationController.pushViewController(view, animated: true)
    }
}
