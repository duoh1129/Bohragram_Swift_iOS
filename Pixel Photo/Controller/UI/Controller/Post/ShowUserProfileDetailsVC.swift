//
//  ShowUserProfileDetailsVC.swift
//  Pixel Photo
//
//  Created by Muhammad Haris Butt on 2/3/20.
//  Copyright © 2020 Olivin Esguerra. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import DropDown
import PixelPhotoSDK
import XLPagerTabStrip
import JGProgressHUD

class ShowUserProfileDetailsVC: BaseVC {
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    public var itemInfo = IndicatorInfo(title: "View")
    
    var object:ShowUserProfileData?
    var descriptionSting:String? = ""
    var gender:String? = ""
    var email:String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    private func setupUI(){
        self.descriptionLabel.text = self.descriptionSting ?? "Hi there i am using PixelPhoto"
        self.emailLabel.text = self.email ?? ""
        self.genderLabel.text = self.gender ?? ""
    }
   
}


extension ShowUserProfileDetailsVC:IndicatorInfoProvider{
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}
