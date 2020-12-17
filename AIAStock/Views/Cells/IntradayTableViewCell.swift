//
//  IntradayTableViewCell.swift
//  AIAStock
//
//  Created by Victor Samuel Cuaca on 16/12/20.
//

import UIKit

final class IntradayTableViewCell: UITableViewCell {

    @IBOutlet var symbolLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var openLabel: UILabel!
    @IBOutlet var highLabel: UILabel!
    @IBOutlet var lowLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func configure(with viewModel: IntradayViewModel) {
        symbolLabel.text = viewModel.symbol
        dateLabel.text = viewModel.dateTime
        openLabel.text = viewModel.open
        highLabel.text = viewModel.high
        lowLabel.text = viewModel.low
    }
}
