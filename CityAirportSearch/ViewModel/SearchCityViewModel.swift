//
//  SearchViewModel.swift
//  CityAirportSearch
//
//  Created by Allie Kim on 2021/09/17.
//

import RxCocoa

protocol SearchCityViewPresentable {
    /// Data From ViewController to ViewModel
    typealias Input = (
        searchText: Driver<String>, ()
    )
    /// Data From ViewModel to ViewController
    typealias Output = ()

    var input: SearchCityViewPresentable.Input { get }
    var output: SearchCityViewPresentable.Output { get }
}

class SearchCityViewModel: SearchCityViewPresentable {

    var input: SearchCityViewPresentable.Input
    var output: SearchCityViewPresentable.Output

    init(input: SearchCityViewPresentable.Input) {
        self.input = input
        self.output = SearchCityViewModel.output(input: self.input)
    }
}

// -MARK: Extension
private extension SearchCityViewModel {

    static func output(input: SearchCityViewPresentable.Input) -> SearchCityViewPresentable.Output {
        return ()
    }
}
