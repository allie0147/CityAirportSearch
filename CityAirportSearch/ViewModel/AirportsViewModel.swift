//
//  AirportViewModel.swift
//  CityAirportSearch
//
//  Created by Allie Kim on 2021/09/26.
//

import RxSwift
import RxCocoa
import RxDataSources

typealias AirportItemSection = SectionModel<Int, AirportViewPresentable>

protocol AirportsViewPresentable {

    typealias Output = (
        title: Driver<String>,
        airports: Driver<[AirportItemSection]>
    )

    typealias Input = (
        selectedAirport: Driver<AirportViewPresentable>, ()
    )

    typealias Dependencies = (
        title: String,
        models: Set<AirportModel>,
        currentLocation: Observable<(lat: Double, lon: Double)?>
    )

    typealias ViewModelBuilder = (AirportsViewPresentable.Input) -> AirportsViewPresentable

    var output: AirportsViewPresentable.Output { get }
    var input: AirportsViewPresentable.Input { get }
}

class AirportsViewModel: AirportsViewPresentable {

    var output: AirportsViewPresentable.Output
    var input: AirportsViewPresentable.Input

    private let bag = DisposeBag()

    // Routers
    private typealias RoutingAction = (selectedAirportRelay: PublishRelay<AirportModel>, ())
    private let routingAction = (selectedAirportRelay: PublishRelay<AirportModel>(), ())
    typealias Routing = (selectedAirport: Driver<AirportModel>, ())
    lazy var router: Routing = (selectedAirport: routingAction.selectedAirportRelay.asDriver(onErrorDriveWith: .empty()), ())

    init(input: AirportsViewPresentable.Input,
         dependencies: AirportsViewPresentable.Dependencies) {
        self.input = input
        self.output = AirportsViewModel.output(dependencies: dependencies)
        self.process(dependencies: dependencies)
    }

}

// MARK: -Extension
private extension AirportsViewModel {

    static func output(dependencies: AirportsViewPresentable.Dependencies) -> AirportsViewPresentable.Output {

        let sections = Observable.just(dependencies.models)
            .withLatestFrom(dependencies.currentLocation) { ($0, $1) }
            .map { args in
            args.0
                .compactMap {
                AirportViewModel(
                    usingModel: $0,
                    currentLocation: args.1 ?? (lat: 0, lon: 0)
                ) }
                .sorted() // sorted by distance (<)
        }
            .map { [AirportItemSection(model: 0, items: $0)] }
            .asDriver(onErrorJustReturn: [])

        return (
            title: Driver.just(dependencies.title),
            airports: sections
        )
    }

    func process(dependencies: AirportsViewPresentable.Dependencies) {
        self.input
            .selectedAirport
            .map { [models = dependencies.models] viewModel in
            models.filter({ $0.code == viewModel.code }).first }
            .filter { $0 != nil } // nil check
        .map { $0! } // force unwrappring
        .map { [routingAction] in
            routingAction.selectedAirportRelay.accept($0)
        }
            .drive() // .modelSelected(AirportViewPresentable.self)
        .disposed(by: bag)
    }
}
