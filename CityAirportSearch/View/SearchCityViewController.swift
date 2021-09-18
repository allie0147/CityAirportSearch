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

    private var viewModel: SearchCityViewPresentable!
    var viewModelBuilder: SearchCityViewPresentable.ViewModelBuilder!

    override func viewDidLoad() {
        super.viewDidLoad()

        // viewModel is created using viewModelBuilder which passes Input
        viewModel = viewModelBuilder((
            searchText: searchTextField.rx.text.orEmpty.asDriver(), ()
        ))
        
        self.title = "Airports"
    }
}

