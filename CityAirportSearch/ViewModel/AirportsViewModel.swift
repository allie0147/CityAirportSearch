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

    typealias Input = ()

    typealias Dependencies = (
        title: String,
        models: Set<AirportModel>,
        currentLocation: Observable<(lat: Double, lon: Double)?>
    )

    typealias ViewModelBuilder = (AirportsViewPresentable.Input) -> AirportsViewPresentable

    var output: AirportsViewPresentable.Output { get }
    var input: AirportsViewPresentable.Input { get }
}

struct AirportsViewModel: AirportsViewPresentable {

    var output: AirportsViewPresentable.Output
    var input: AirportsViewPresentable.Input

    init(input: AirportsViewPresentable.Input,
         dependencies: AirportsViewPresentable.Dependencies) {
        self.input = input
        self.output = AirportsViewModel.output(dependencies: dependencies)
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
}
