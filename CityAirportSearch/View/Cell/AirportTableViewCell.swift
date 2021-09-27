//
//  AirportTableViewCell.swift
//  CityAirportSearch
//
//  Created by Allie Kim on 2021/09/27.
//

import UIKit

class AirportTableViewCell: UITableViewCell {
    static let identifier = "AirportTableViewCell"

    @IBOutlet weak var airportNameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var lengthLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(usingViewModel viewModel: AirportViewPresentable) {
        self.airportNameLabel.text = viewModel.name
        self.distanceLabel.text = "\(viewModel.distance ?? 0)"
        self.countryLabel.text = viewModel.address
        self.lengthLabel.text = viewModel.runwayLength
        self.selectionStyle = .none
    }
}
