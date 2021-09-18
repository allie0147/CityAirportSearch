//
//  AppCoordinator.swift
//  CityAirportSearch
//
//  Created by Allie Kim on 2021/09/18.
//

import UIKit

/// parent coordinator, starts window launching app
class AppCoordinator: BaseCoordinator {

    private let window: UIWindow

    private let navigationController: UINavigationController = {
        let nav = UINavigationController()

        let navBar = nav.navigationBar
        navBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navBar.shadowImage = UIImage()
        navBar.barTintColor = UIColor(red: 233.0 / 255.0, green: 55.0 / 255.0, blue: 72.0 / 255.0, alpha: 1.0)
        navBar.tintColor = .white
        navBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont(name: "Avenir-Medium", size: 28.0)!,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        navBar.isTranslucent = false
        return nav
    }()

    init(window: UIWindow) {
        self.window = window
    }

    override func start() {
        let seacrhCityCoordinator = SearchCityCoordinator(navigation: navigationController)
        self.add(coordinator: seacrhCityCoordinator)
        seacrhCityCoordinator.start()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
