//
//  SearchViewModel.swift
//  CityAirportSearch
//
//  Created by Allie Kim on 2021/09/17.
//

import RxCocoa
import RxSwift

protocol SearchCityViewPresentable {
    /// Data From ViewController to ViewModel
    typealias Input = (
        searchText: Driver<String>, ()
    )
    /// Data From ViewModel to ViewController
    typealias Output = ()

    /// as presentable : passing Input makes ViewModel
    typealias ViewModelBuilder = (SearchCityViewPresentable.Input) -> SearchCityViewPresentable

    var input: SearchCityViewPresentable.Input { get }
    var output: SearchCityViewPresentable.Output { get }
}

class SearchCityViewModel: SearchCityViewPresentable {

    var input: SearchCityViewPresentable.Input
    var output: SearchCityViewPresentable.Output
    private let airportService: AirportAPI

    private let bag = DisposeBag()

    /// API response state with Set of AirportModel
    typealias State = (airports: BehaviorRelay<Set<AirportModel>>, ())
    /// API response state with Set of AirportModel
    private let state: State = (airports: BehaviorRelay<Set<AirportModel>>(value: []), ())

    init(input: SearchCityViewPresentable.Input,
         airportService: AirportAPI) {
        self.input = input
        self.output = SearchCityViewModel.output(
            input: self.input,
            state: state,
            bag: bag
        )
        self.airportService = airportService
        self.process()
    }
}

// -MARK: Extension
private extension SearchCityViewModel {

    static func output(input: SearchCityViewPresentable.Input,
                       state: State,
                       bag: DisposeBag) -> SearchCityViewPresentable.Output {
        Observable
            .combineLatest(
            input.searchText.asObservable(),
            state.airports.asObservable()
        )
            .map { (searchKey, airports) in
            airports.filter { (airport) -> Bool in // filtering searchText
                return !searchKey.isEmpty &&
                    ((airport
                    .city?
                    .lowercased()
                    .replacingOccurrences(of: " ", with: "")
                    .hasPrefix(searchKey.lowercased())) != nil)
            }
        }
            .map {
            print($0)
        }.subscribe()
            .disposed(by: bag)

        return ()
    }

    /// get data from API Service
    func process() {
        self.airportService
            .fetchAirports()
            .map { Set($0) } // conver array to Set
        .map { [state] in
            state.airports.accept($0)
        }
            .subscribe()
            .disposed(by: bag)
    }
}
