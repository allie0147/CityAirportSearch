//
//  AirportViewController.swift
//  CityAirportSearch
//
//  Created by Allie Kim on 2021/09/26.
//

import UIKit
import RxSwift
import RxDataSources

class AirportViewController: UIViewController, Storyboardable {

    @IBOutlet weak var airportTableView: UITableView!

    private var viewModel: AirportsViewPresentable!

    var viewModelBuilder: AirportsViewPresentable.ViewModelBuilder!

    private let bag = DisposeBag()

    private lazy var dataSource = RxTableViewSectionedReloadDataSource<AirportItemSection> { _, tableView, index, item in
        let cell = tableView.dequeueReusableCell(withIdentifier: AirportTableViewCell.identifier, for: index) as! AirportTableViewCell
        cell.configure(usingViewModel: item)
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = viewModelBuilder((
            selectedAirport: self.airportTableView.rx
                .modelSelected(AirportViewPresentable.self)
                .asDriver(onErrorDriveWith: .empty()),
            ()
        ))
        setupUI()
        setupBinding()
    }
}

// MARK: -Extension
private extension AirportViewController {

    func setupUI() {
        airportTableView.register(
            UINib(nibName: AirportTableViewCell.identifier, bundle: nil),
            forCellReuseIdentifier: AirportTableViewCell.identifier)
    }

    func setupBinding() {

        self.viewModel.output.airports
            .drive(
            self.airportTableView.rx
                .items(dataSource: dataSource)
        )
            .disposed(by: bag)

        self.viewModel.output.title
            .drive(self.rx.title)
            .disposed(by: bag)
    }
}

