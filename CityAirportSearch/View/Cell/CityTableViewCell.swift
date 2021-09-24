//
//  CityTableViewCell.swift
//  CityAirportSearch
//
//  Created by Allie Kim on 2021/09/25.
//

import UIKit

class CityTableViewCell: UITableViewCell {
    static let identifier = "CityTableViewCell"

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(usingViewModel viewModel: CityViewPresentable) {

        self.cityLabel.text = viewModel.city
        self.locationLabel.text = viewModel.location
    }
}
