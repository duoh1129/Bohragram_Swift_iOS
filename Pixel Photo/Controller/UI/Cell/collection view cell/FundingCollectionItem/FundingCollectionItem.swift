//
//  FundingCollectionItem.swift
//  Pixel Photo
//
//  Created by Muhammad Haris Butt on 1/28/20.
//  Copyright © 2020 Olivin Esguerra. All rights reserved.
//

import UIKit
import LinearProgressBar
class FundingCollectionItem: UICollectionViewCell {

    @IBOutlet weak var linearBar: LinearProgressBar!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thumbnailImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func bind(_ object:FetchFundingModel.Datum){
        let thumbnailIamg = URL(string: object.image ?? "")
        self.thumbnailImage.sd_setImage(with: thumbnailIamg , placeholderImage:R.image.img_item_placeholder())
        self.descriptionLabel.text = "$\(object.raised ?? 0) Raised of $\(object.amount ?? "")"
        self.titleLabel.text = object.title ?? ""
        self.linearBar.progressValue = CGFloat(object.bar ?? 0.0)
    }
}
