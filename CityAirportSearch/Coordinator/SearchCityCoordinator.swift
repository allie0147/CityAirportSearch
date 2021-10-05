//
//  SearchCityCoordinator.swift
//  CityAirportSearch
//
//  Created by Allie Kim on 2021/09/18.
//

import UIKit
import RxSwift

class SearchCityCoordinator: BaseCoordinator {
    private let router: Routing

    private let bag = DisposeBag()

    init(router: Routing) {
        self.router = router
    }

    override func start() {
        let view = SearchCityViewController.instantiate()
        let service = AirportService.shared

        view.viewModelBuilder = { [bag] in
            let viewModel = SearchCityViewModel(input: $0,
                                                airportService: service)

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

        router.push(view, isAnimated: true, onNavigationBack: isCompleted)
    }
}

// MARK: -Extension
private extension SearchCityCoordinator {

    /// push `viewController` to `child viewController` and handle `isCompleted` action
    func showAirports(usingModels models: Set<AirportModel>) {
        let airportsCoordinator = AirportCoordinator(models: models,
                                                     router: self.router)
        self.add(coordinator: airportsCoordinator)

        airportsCoordinator.isCompleted = { [weak self, weak airportsCoordinator] in
            guard let coordinator = airportsCoordinator else {
                return
            }
            self?.remove(coordinator: coordinator)
        }

        airportsCoordinator.start()
    }
}
