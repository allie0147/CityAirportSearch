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

    init(input: SearchCityViewPresentable.Input,
         airportService: AirportAPI) {
        self.input = input
        self.output = SearchCityViewModel.output(input: self.input)
        self.airportService = airportService
        self.process()
    }
}

// -MARK: Extension
private extension SearchCityViewModel {

    static func output(input: SearchCityViewPresentable.Input) -> SearchCityViewPresentable.Output {
        return ()
    }

    func process() {
        self.airportService.fetchAirports()
            .subscribe()
            .disposed(by: bag)
    }
}
