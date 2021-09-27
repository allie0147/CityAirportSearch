//
//  SearchCityCoordinator.swift
//  CityAirportSearch
//
//  Created by Allie Kim on 2021/09/18.
//

import UIKit
import RxSwift

class SearchCityCoordinator: BaseCoordinator {
    private let navigationController: UINavigationController

    private let bag = DisposeBag()

    init(navigation: UINavigationController) {
        self.navigationController = navigation
    }

    override func start() {
        let view = SearchCityViewController.instantiate()
        let service = AirportService.shared

        view.viewModelBuilder = { [bag] in
            let viewModel = SearchCityViewModel(input: $0, airportService: service)

            viewModel.router.selectedCity
                .map { [weak self] in
//                    print("Models received: \($0)")
                guard let `self` = self else { return }
                self.showAirports(usingModels: $0)
            }
                .drive()
                .disposed(by: bag)

            return viewModel
        }

        navigationController.pushViewController(view, animated: true)
    }
}

// MARK: -Extension
private extension SearchCityCoordinator {

    /// push viewController to child viewController
    func showAirports(usingModels models: Set<AirportModel>) {
        let airportsCoordinator = AirportCoordinator(models: models, navigation: self.navigationController)
        self.add(coordinator: airportsCoordinator)
        airportsCoordinator.start()
    }
}
