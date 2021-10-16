//
//  AirportDetailsViewModel.swift
//  CityAirportSearch
//
//  Created by Allie Kim on 2021/10/09.
//

import Foundation
import RxSwift
import RxCocoa

protocol AirportDetailsViewPresentable {

    typealias Input = ()
    typealias Output = (
        airportDetails: Driver<AirportViewPresentable>,
        mapDetails: Driver<AirportMapViewPresentable>
    )
    typealias Dependencies = (
        model: AirportModel,
        currentLocation: Observable<(lat: Double, lon: Double)?>
    )
    typealias ViewModelBuilder = (AirportDetailsViewPresentable.Input) -> AirportDetailsViewPresentable

    var input: AirportDetailsViewPresentable.Input { get }
    var output: AirportDetailsViewPresentable.Output { get }

}

class AirportDetailsViewModel: AirportDetailsViewPresentable {

    var input: AirportDetailsViewPresentable.Input
    var output: AirportDetailsViewPresentable.Output

    init(input: AirportDetailsViewPresentable.Input,
         dependencies: AirportDetailsViewPresentable.Dependencies) {
        self.input = input
        self.output = AirportDetailsViewModel.output(input: input,
                                                     dependencies: dependencies)
    }

}

private extension AirportDetailsViewModel {

    static func output(input: AirportDetailsViewPresentable.Input,
                       dependencies: AirportDetailsViewPresentable.Dependencies) -> AirportDetailsViewPresentable.Output {

        let airportDetails: Driver<AirportViewPresentable> = dependencies.currentLocation
            .filter { $0 != nil }
            .map { $0! }
            .map { [airportModel = dependencies.model] (currentLocation) in
            AirportViewModel(usingModel: airportModel, currentLocation: currentLocation)
        }
            .asDriver(onErrorDriveWith: .empty())

        let mapDetails: Driver<AirportMapViewPresentable> = dependencies.currentLocation
            .filter { $0 != nil }
            .map { $0! }
            .map { [airportModel = dependencies.model] (currentLocation) in

            guard let lat = Double(airportModel.lat),
                let lon = Double(airportModel.lon) else {
                throw CustomError.error(message: "Airport Location Missing")
            }

            let airportLocation = (lat: lat, lon: lon)

            return AirportMapViewModel(
                airport: (
                    name: airportModel.name
                    , city: airportModel.city ?? "NA"
                ),
                currentLocation: currentLocation,
                airportLocation: airportLocation
            )
        }
            .asDriver(onErrorDriveWith: .empty())

        return (
            airportDetails: airportDetails,
            mapDetails: mapDetails
        )
    }
}
