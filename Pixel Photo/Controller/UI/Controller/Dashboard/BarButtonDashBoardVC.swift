//
//  BarButtonDashBoardVC.swift
//  Pixel Photo
//
//  Created by Abdul Moid on 19/04/2021.
//  Copyright © 2021 Olivin Esguerra. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class BarButtonDashBoardVC: ButtonBarPagerTabStripViewController {

    lazy var storeVC = R.storyboard.store.storeVC()
    var storePosts = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let filterButton = UIBarButtonItem(image: UIImage(named: "abacus"), style: .plain, target: self, action: #selector(logoutUser))
        filterButton.tintColor = .label
        self.navigationItem.rightBarButtonItem  = filterButton

        // Sets the background colour of the pager strip and the pager strip item
        settings.style.buttonBarBackgroundColor = .systemBackground
        settings.style.buttonBarItemBackgroundColor = .systemBackground

        // Sets the pager strip item font and font color
        settings.style.buttonBarItemFont = UIFont.systemFont(ofSize: 16, weight: .light)
        if #available(iOS 13.0, *) {
            settings.style.buttonBarItemTitleColor = .label
        } else {
            settings.style.buttonBarItemTitleColor = .black
        }
        // Sets the pager strip item offsets
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
        buttonBarView.selectedBar.backgroundColor = .mainColor
        buttonBarView.selectedBar.heightAnchor.constraint(equalToConstant: 10).isActive = true
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
//            oldCell?.label.text = "Store"
            oldCell?.label.textColor = .label
            newCell?.label.textColor = .label
            print("OldCell",oldCell)
            print("NewCell",newCell)
        }
    }
    
    @objc func logoutUser(){
        let Storyboard = UIStoryboard(name: "Store", bundle: nil)
        let vc = Storyboard.instantiateViewController(withIdentifier: "StoreFilterVC") as! StoreFilterController
        vc.delegate = self.storeVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tabBar = self.tabBarController as! TabbarController
        tabBar.button.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let tabBar = self.tabBarController as! TabbarController
        tabBar.button.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        storeVC?.storeArray = self.storePosts
        let mysotore = R.storyboard.store.myStoreVC()
        let mydownloads = R.storyboard.store.myDownloadsVC()
        return [storeVC!,mysotore!,mydownloads!]
        
    }
    

}
