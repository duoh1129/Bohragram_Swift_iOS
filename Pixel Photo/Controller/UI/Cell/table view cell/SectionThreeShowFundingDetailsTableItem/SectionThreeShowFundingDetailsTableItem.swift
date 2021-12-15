//
//  SectionThreeShowFundingDetailsTableItem.swift
//  Pixel Photo
//
//  Created by Muhammad Haris Butt on 1/29/20.
//  Copyright © 2020 Olivin Esguerra. All rights reserved.
//

import UIKit
import PixelPhotoSDK
class SectionThreeShowFundingDetailsTableItem: UITableViewCell {
    
    var object:FetchFundingModel.Datum?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    func bind(_ object:FetchFundingModel.Datum){
        self.object = object
        
    }
    @IBAction func donatePressed(_ sender: Any) {
        guard let url = URL(string: API.baseURL) else {
          return //be safe
        }

        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
        
    }
}
