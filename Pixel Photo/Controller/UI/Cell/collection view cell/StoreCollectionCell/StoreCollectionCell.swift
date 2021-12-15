//
//  StoreCollectionCell.swift
//  Pixel Photo
//
//  Created by Ubaid Javaid on 6/19/20.
//  Copyright © 2020 Olivin Esguerra. All rights reserved.
//

import UIKit

class StoreCollectionCell: UICollectionViewCell {

    
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var price: RoundLabel!
    @IBOutlet weak var downloadLabel: RoundLabel!
    @IBOutlet weak var CategoryLabel: UILabel!
    @IBOutlet weak var views: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
