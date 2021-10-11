//
//  AirportDetailsViewController.swift
//  CityAirportSearch
//
//  Created by Allie Kim on 2021/10/07.
//

import UIKit
import MapKit
import RxSwift

class AirportDetailsViewController: UIViewController, Storyboardable {

    // MARK: -UI
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var airportNameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var runwayLengthLabel: UILabel!

    private var viewModel: AirportDetailsViewPresentable!
    var viewModelBuilder: AirportDetailsViewPresentable.ViewModelBuilder!

    private let bag = DisposeBag()


    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewModel = viewModelBuilder(())
        self.setupUI()
        self.setupBinding()
    }
}

private extension AirportDetailsViewController {

    func setupUI() {


    }

    func setupBinding() {

        self.viewModel.output.airportDetails
            .map { [weak self] viewModel in
            self?.airportNameLabel.text = viewModel.name
            self?.distanceLabel.text = viewModel.formattedDistance
            self?.countryLabel.text = viewModel.address
            self?.runwayLengthLabel.text = viewModel.runwayLength
        }
            .drive()
            .disposed(by: bag)
    }

}
