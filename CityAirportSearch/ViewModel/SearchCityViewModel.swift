//
//  SearchViewModel.swift
//  CityAirportSearch
//
//  Created by Allie Kim on 2021/09/17.
//

import RxCocoa
import RxSwift
import RxDataSources

protocol SearchCityViewPresentable {
    /// Data From ViewController to ViewModel
    typealias Input = (
        searchText: Driver<String>,
        selectedCity: Driver<CityViewModel>
    )

    /// Data From ViewModel to ViewController
    typealias Output = (
        cities: Driver<[CityItemsSection]>, ()
    )

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

    // Routers
    private typealias RoutingAction = (selectedCityRelay: PublishRelay<Set<AirportModel>>, ())
    private let routingAction: RoutingAction = (selectedCityRelay: PublishRelay(), ())
    typealias Routing = (selectedCity: Driver<Set<AirportModel>>, ())
    lazy var router: Routing = (selectedCity: self.routingAction.selectedCityRelay.asDriver(onErrorDriveWith: .empty()), ())

    init(input: SearchCityViewPresentable.Input,
         airportService: AirportAPI) {
        self.input = input
        self.output = SearchCityViewModel.output(
            input: self.input,
            state: state
        )
        self.airportService = airportService
        self.process()
    }
}

// -MARK: Extension
private extension SearchCityViewModel {

    static func output(input: SearchCityViewPresentable.Input,
                       state: State) -> SearchCityViewPresentable.Output {

        let searchTextObservable = input.searchText
            .debounce(.milliseconds(300)) // get text after 300 millis
        .distinctUntilChanged() // prevent duplicated text
        .skip(1) // skip first value so that it doesn't send any empty signal as it subscribed
        .asObservable()
            .share(replay: 1, scope: .whileConnected) // share observable (cold observable)

        let airportObservable = state.airports.skip(1).asObservable()

        let sections = Observable
            .combineLatest(
            searchTextObservable,
            airportObservable
        )
            .map { (searchKey, airports) in
            return airports.filter { (airport) -> Bool in // filtering searchText
                !searchKey.isEmpty &&
                    ((airport.city?
                    .lowercased()
                    .replacingOccurrences(of: " ", with: "")
                    .hasPrefix(searchKey.lowercased())) ?? false)
            }
        }
            .map {
            // Transform AirportModel to CityViewModel
            uniqueElementsFrom(array: $0.compactMap { CityViewModel(model: $0) })
        }
            .map {
            // Transform into RxDataSources
            [CityItemsSection(model: 0, items: $0)]
        }
            .asDriver(onErrorJustReturn: [])

        return (cities: sections, ())
    }

    /// Get data from API Service
    func process() {
        self.airportService
            .fetchAirports()
            .map { Set($0) } // conver array to Set
        .map { [state] in
            state.airports.accept($0)
        }
            .subscribe()
            .disposed(by: bag)

        self.input.selectedCity
            .map { $0.city }
            .withLatestFrom(state.airports.asDriver()) { (city: $0, airports: $1) }
            .map { (city, airports) in
            airports.filter { $0.city == city }
        }
            .map { [routingAction] in
//            print("Airports selected: \($0)")

            // accept AirportViewModel which is selected
            routingAction.selectedCityRelay.accept($0)
        }
            .drive()
            .disposed(by: bag)
    }
}

// MARK: -Extension: SearchCityViewModel
private extension SearchCityViewModel {

    /// Get one airport from city
    static func uniqueElementsFrom(array: [CityViewModel]) -> [CityViewModel] {
        // Create an empty Set to track unique items
        var set = Set<CityViewModel>()
        return array.filter {
            guard !set.contains($0) else {
                // If the set already contains this object, return false
                // so skip it
                return false
            }
            // ADD this item to the set since it will now be in the array
            set.insert($0)
            // Retrun true so that filtered array will contain this item.
            return true
        }
    }
}
