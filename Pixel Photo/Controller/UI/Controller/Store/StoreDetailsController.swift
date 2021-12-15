//
//  StoreDetailsController.swift
//  Pixel Photo
//
//  Created by Ubaid Javaid on 7/25/20.
//  Copyright © 2020 Olivin Esguerra. All rights reserved.
//

import UIKit
import SDWebImage
//Price outlet is not created
class StoreDetailsController: UIViewController {
    
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var thumbnailImage: RoundImage!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var imageTypeLabel: UILabel!
    @IBOutlet weak var viewLabel: UILabel!
    @IBOutlet weak var downloads: UILabel!
    @IBOutlet weak var sellsLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var catLabel: UILabel!
    @IBOutlet weak var imgeTyLabel: UILabel!
    @IBOutlet weak var viewsLbl: UILabel!
    
    @IBOutlet weak var downloadLbl: UILabel!
    
    @IBOutlet weak var sellsLbl: UILabel!
    
    @IBOutlet weak var tagsLbl: UILabel!
    
    @IBOutlet weak var priceLbl : UILabel!
    
    @IBOutlet weak var butBtn: RoundButton!
    var storeDetails = [String:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let coverImage = self.storeDetails["thumb"] as? String{
            let url = URL(string: coverImage)
            self.coverImage.sd_setImage(with: url, completed: nil)
        }
        if let avatar = self.storeDetails["avatar"] as? String{
            let url = URL(string: avatar)
            self.thumbnailImage.sd_setImage(with: url, completed: nil)
        }
        if let title = self.storeDetails["title"] as? String{
            self.titleLabel.text = title
        }
        if let tags = self.storeDetails["tags"] as? String{
            self.tagsLabel.text = tags
        }
        if let views = self.storeDetails["views"] as? Int{
            self.viewLabel.text = "\(views)"
        }
        if let sells = self.storeDetails["sells"] as? Int{
            self.sellsLabel.text = "\(sells)"
        }
        if let downloads = self.storeDetails["downloads"] as? Int{
            self.downloads.text = "\(downloads)"
        }
        if let category = self.storeDetails["category_name"] as? String{
            self.categoryLabel.text = category
        }
        if let type = self.storeDetails["type"] as? String{
            self.imageTypeLabel.text = type
        }
        guard let prices = storeDetails["license_options"] as? [String:Any] else {
            print("Can't Parse the value 0.1")
            return
        }
        print("->>>\(prices)")
        print("->>>\(prices.values)")
        for value in Array(prices) {
            self.priceLbl.text = ("\(value.key) $ \(value.value)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.catLabel.text = NSLocalizedString("Category", comment: "Category")
        self.imgeTyLabel.text = NSLocalizedString("Image Typ", comment: "Image Typ")
        self.viewsLbl.text = NSLocalizedString("Views", comment: "Views")
        self.sellsLbl.text = NSLocalizedString("sells", comment: "sells")
        self.downloadLbl.text = NSLocalizedString("Downloads", comment: "Downloads")
        self.tagsLbl.text = NSLocalizedString("Tags", comment: "Tags")
        self.butBtn.setTitle(NSLocalizedString("Buy", comment: "Buy"), for: .normal)
        view.backgroundColor = UIColor.mainColor
        butBtn.backgroundColor = UIColor.mainColor
    }
    

    @IBAction func Back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buyButton(_ sneder : Any){
    
        let vc = R.storyboard.popup.paymentPopVC()
        
        vc?.modalPresentationStyle = .overCurrentContext
        vc?.modalTransitionStyle = .crossDissolve
        
        self.present(vc!, animated: true, completion: nil)
        
        
        
    }
    

}
