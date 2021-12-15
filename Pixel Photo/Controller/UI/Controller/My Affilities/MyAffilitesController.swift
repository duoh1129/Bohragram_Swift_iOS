//
//  MyAffilitesController.swift
//  Pixel Photo
//
//  Created by Ubaid Javaid on 8/27/20.
//  Copyright © 2020 Olivin Esguerra. All rights reserved.
//

import UIKit
import SDWebImage
class MyAffilitesController: UIViewController {

    @IBOutlet weak var profileImage: RoundImage!
    @IBOutlet weak var urlLinkBtn: UIButton!
    
    @IBOutlet weak var shareBtn: RoundButton!
    
    @IBOutlet weak var earnLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("My Affilities", comment: "My Affilities")
        let yourBackImage = UIImage(named: "left-arrows")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    self.profileImage.sd_setImage(with: URL(string:AppInstance.instance.userProfile?.data?.avatar ?? ""), completed: nil)
    self.urlLinkBtn.setTitle(AppInstance.instance.userProfile?.data?.url ?? "", for: .normal)
        self.shareBtn.setTitle(NSLocalizedString("Share To", comment: "Share To"), for: .normal)
        self.earnLabel.text = NSLocalizedString("Earn upto $0.10 for each user your refer to us!", comment: "Earn upto $0.10 for each user your refer to us!")
    }
    
    @IBAction func Share(_ sender: Any) {
        let myWebsite = NSURL(string: AppInstance.instance.userProfile?.data?.url ?? "")
           let shareAll = [myWebsite] as [Any]
           let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
           self.present(activityViewController, animated: true, completion: nil)
    }
    

}
