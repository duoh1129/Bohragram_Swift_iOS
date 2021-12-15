//
//  AllStoreCells.swift
//  Pixel Photo
//
//  Created by Ubaid Javaid on 7/27/20.
//  Copyright © 2020 Olivin Esguerra. All rights reserved.
//

import UIKit

class AllStoreCells: UICollectionViewCell {
   
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
