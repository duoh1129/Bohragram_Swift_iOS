//
//  ShowDetailsSectionOneTableItem.swift
//  Pixel Photo
//
//  Created by Muhammad Haris Butt on 1/29/20.
//  Copyright © 2020 Olivin Esguerra. All rights reserved.
//

import UIKit

class ShowDetailsSectionOneTableItem: UITableViewCell {
    
    @IBOutlet weak var thumbailImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func bind(_ object:FetchFundingModel.Datum){
        self.titleLabel.text = object.title ?? ""
        self.descriptionLabel.text = object.datumDescription?.htmlAttributedString ?? ""
        let thumbnailIamg = URL(string: object.image ?? "")
        self.thumbailImage.sd_setImage(with: thumbnailIamg , placeholderImage:R.image.img_item_placeholder())
    }
}
