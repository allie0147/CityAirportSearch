//
//  AirportCoordinator.swift
//  CityAirportSearch
//
//  Created by Allie Kim on 2021/09/26.
//

import UIKit

class AirportCoordinator: BaseCoordinator {

    private let navigationController: UINavigationController

    init(navigation: UINavigationController) {
        self.navigationController = navigation
    }

    override func start() {
        let view = AirportViewController.instantiate()
        navigationController.pushViewController(view, animated: true)
    }
}
