//
//  ViewController.swift
//  CityAirportSearch
//
//  Created by Allie Kim on 2021/09/17.
//

import UIKit
import RxSwift
import RxDataSources

class SearchCityViewController: UIViewController {

    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchTableView: UITableView!

    var viewModel: SearchCityViewPresentable!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

