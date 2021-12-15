//
//  SectionTwoTableItem.swift
//  Pixel Photo
//
//  Created by Muhammad Haris Butt on 1/29/20.
//  Copyright © 2020 Olivin Esguerra. All rights reserved.
//

import UIKit
import LinearProgressBar
class SectionTwoTableItem: UITableViewCell {

    @IBOutlet weak var priceRangeLabel: UILabel!
    @IBOutlet weak var linearBar: LinearProgressBar!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func bind(_ object:FetchFundingModel.Datum){
            self.priceRangeLabel.text = "$\(object.raised ?? 0) Raised of $\(object.amount ?? "")"
            self.linearBar.progressValue = CGFloat(object.bar ?? 0.0)
        }
    
}
