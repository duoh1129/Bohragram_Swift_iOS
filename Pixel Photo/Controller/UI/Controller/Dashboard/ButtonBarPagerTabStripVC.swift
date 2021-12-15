//
//  ButtonBarPagerTabStripVC.swift
//  Pixel Photo
//
//  Created by Mac on 08/04/2021.
//  Copyright © 2021 Olivin Esguerra. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class ButtonBarPagerTabStripVC: BarPagerTabStripViewController {
    
    //    @IBOutlet weak var buttonBarView: ButtonBarView!
    //    @IBOutlet weak var containerView: UIScrollView!
    
    
    var storePosts = [[String:Any]]()
    
    override func viewDidLoad() {
        print("Hello World")
        super.viewDidLoad()
//        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
//            guard changeCurrentIndex == true else { return }
//            oldCell?.label.text = "Store"
//            oldCell?.label.textColor = UIColor.black
//            newCell?.label.textColor = .mainColor
//            print("OldCell",oldCell)
//            print("NewCell",newCell)
//        }
        // Do any additional setup after loading the view.
    }
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let storeVC = R.storyboard.store.storeVC()
        storeVC?.storeArray = self.storePosts
        //            let chatVC = R.storyboard.dashboard.chatVC()
        //  let groupVC = R.storyboard.dashboard.groupVC()
        //  let storiesVC = R.storyboard.dashboard.storiesVC()
        //  let callVC = R.storyboard.dashboard.callVC()
        return [storeVC!]//[chatVC!,groupVC!,storiesVC!,callVC!]
        
    }
    
    
}
