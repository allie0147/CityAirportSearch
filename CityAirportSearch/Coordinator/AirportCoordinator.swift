//
//  AirportCoordinator.swift
//  CityAirportSearch
//
//  Created by Allie Kim on 2021/09/26.
//

import UIKit
import RxSwift

class AirportCoordinator: BaseCoordinator {

    private let router: Routing
    private let models: Set<AirportModel>
    private let bag = DisposeBag()

    init(models: Set<AirportModel>,
         router: Routing) {
        self.router = router
        self.models = models
    }

    override func start() {
        let view = AirportViewController.instantiate()
        let locationService = LocationService.shared

        view.viewModelBuilder = { [locationService, models, bag] in
            let title = models.first?.city ?? ""
            let viewModel = AirportsViewModel(
                input: $0,
                dependencies: (title: title,
                               models: models,
                               currentLocation: locationService.currentLocation)
            )

            viewModel.router.selectedAirport.map { [weak self] model in
                self?.showAirportDetails(model: model)
            }
                .drive()
                .disposed(by: bag)

            return viewModel
        }

        router.push(view, isAnimated: true, onNavigationBack: isCompleted)
    }
}

// MARK: -Extension
private extension AirportCoordinator {

    func showAirportDetails(model: AirportModel) {

        let detailsCoordinator = AirportDetailsCoordinator(model: model,
                                                           router: self.router)
        self.add(coordinator: detailsCoordinator)

        detailsCoordinator.isCompleted = { [weak self, weak detailsCoordinator] in
            guard let coordinator = detailsCoordinator else {
                return
            }
            self?.remove(coordinator: coordinator)
        }

        detailsCoordinator.start()
    }
}
