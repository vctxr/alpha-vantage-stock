//
//  DailyAdjustedTableViewCell.swift
//  AIAStock
//
//  Created by Victor Samuel Cuaca on 16/12/20.
//

import UIKit

class DailyAdjustedTableViewCell: UITableViewCell {

    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var firstSymbolLabel: UILabel!
    @IBOutlet var secondSymbolLabel: UILabel!
    @IBOutlet var thirdSymbolLabel: UILabel!
    @IBOutlet var firstOpenLabel: UILabel!
    @IBOutlet var secondOpenLabel: UILabel!
    @IBOutlet var thirdOpenLabel: UILabel!
    @IBOutlet var firstLowLabel: UILabel!
    @IBOutlet var secondLowLabel: UILabel!
    @IBOutlet var thirdLowLabel: UILabel!
    @IBOutlet var thirdStackView: UIStackView!
    
    private var symbolLabels: [UILabel] {
        [firstSymbolLabel, secondSymbolLabel, thirdSymbolLabel]
    }

    private var openLabels: [UILabel] {
        [firstOpenLabel, secondOpenLabel, thirdOpenLabel]
    }
    
    private var lowLabels: [UILabel] {
        [firstLowLabel, secondLowLabel, thirdLowLabel]
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func configure(with viewModel: DailyAdjustedViewModel) {
        thirdStackView.isHidden = (viewModel.symbol.count < 3) ? true : false
        
        dateLabel.text = viewModel.dateTime
                
        for i in 0..<viewModel.symbol.count {
            symbolLabels[i].text = viewModel.symbol[i]
            openLabels[i].text = viewModel.open[i]
            lowLabels[i].text = viewModel.low[i]
        }
    }
}
