//
//  ViewController.swift
//  CityAirportSearch
//
//  Created by Allie Kim on 2021/09/17.
//

import UIKit
import RxSwift
import RxDataSources

class SearchCityViewController: UIViewController, Storyboardable {

    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchTableView: UITableView!

    private let disposeBag = DisposeBag()
    private var viewModel: SearchCityViewPresentable!
    var viewModelBuilder: SearchCityViewPresentable.ViewModelBuilder!

    private lazy var dataSource = RxTableViewSectionedReloadDataSource<CityItemsSection> { _, tableView, index, item in
        let cityCell = tableView.dequeueReusableCell(withIdentifier: CityTableViewCell.identifier, for: index) as! CityTableViewCell
        cityCell.configure(usingViewModel: item)
        return cityCell
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // viewModel is created using viewModelBuilder which passes Input
        viewModel = viewModelBuilder((
            searchText: searchTextField.rx.text.orEmpty.asDriver(),
            selectedCity: searchTableView.rx.modelSelected(CityViewModel.self).asDriver()
        ))

        setupUI()
        setupBinding()
    }
}

//MARK: -Extension
private extension SearchCityViewController {

    func setupUI() {
        self.title = "Airports"
        searchTableView.register(UINib(nibName: CityTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: CityTableViewCell.identifier)
    }

    func setupBinding() {
        self.viewModel.output.cities
            .drive(searchTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}
