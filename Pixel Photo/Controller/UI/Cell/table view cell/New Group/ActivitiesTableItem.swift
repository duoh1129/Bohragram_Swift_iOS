//
//  ActivitiesTableItem.swift
//  Pixel Photo
//
//  Created by Muhammad Haris Butt on 2/3/20.
//  Copyright © 2020 Olivin Esguerra. All rights reserved.
//

import UIKit

class ActivitiesTableItem: UITableViewCell {

    @IBOutlet weak var iconLabel: UIImageView!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thumbnailImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
